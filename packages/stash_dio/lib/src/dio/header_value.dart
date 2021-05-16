import 'dart:collection';

/// Header parser
class _HeaderValue implements HeaderValue {
  /// The header to parse
  String _value;

  /// The parsed parameters out of the header value
  Map<String, String?>? _parameters;

  /// A unmodifiable version of the parse parameters.
  Map<String, String?>? _unmodifiableParameters;

  /// Builds a [_HeaderValue] out of a plain string header and a list of parameters
  ///
  /// * [_value]: The header directive
  /// * [_parameters]: The list of parameters
  ///
  /// Returns a new [_HeaderValue]
  _HeaderValue([this._value = '', Map<String, String>? parameters]) {
    if (parameters != null) {
      _parameters = Map<String, String>.from(parameters);
    }
  }

  /// Parses a [_HeaderValue] from a plain string
  ///
  /// * [value]: The header directive
  /// * [parametersSeparator]: The parameter separator, defaults to ;
  /// * [valueSeparator]: The value separator
  /// * [preserveBackslash]: If the backslash should be preserved, defaults to false
  ///
  /// Returns the parsed [_HeaderValue]
  static _HeaderValue parse(String value,
      {String parameterSeparator = ';',
      String? valueSeparator,
      bool preserveBackslash = false}) {
    // Parse the string.
    var result = _HeaderValue();
    result._parse(value, parameterSeparator, valueSeparator, preserveBackslash);
    return result;
  }

  @override
  String get value => _value;

  /// Ensures that the parameters have a non-null value
  void _ensureParameters() {
    _parameters ??= <String, String>{};
  }

  @override
  Map<String, String?>? get parameters {
    _ensureParameters();
    _unmodifiableParameters ??= UnmodifiableMapView(_parameters!);
    return _unmodifiableParameters;
  }

  @override
  String toString() {
    var sb = StringBuffer();
    sb.write(_value);
    if (parameters != null && parameters!.isNotEmpty) {
      _parameters!.forEach((String name, String? value) {
        sb..write('; ')..write(name)..write('=')..write(value);
      });
    }
    return sb.toString();
  }

  /// Parses a header directive
  ///
  /// * [s]: The header directive
  /// * [parameterSeparator]: The parameter separator
  /// * [valueSeparator]: The value separator
  /// * [preserveBackslash]: If the backslash should be preserved
  void _parse(String s, String parameterSeparator, String? valueSeparator,
      bool preserveBackslash) {
    var index = 0;

    bool done() => index == s.length;

    void skipWS() {
      while (!done()) {
        if (s[index] != ' ' && s[index] != '\t') return;
        index++;
      }
    }

    String parseValue() {
      var start = index;
      while (!done()) {
        if (s[index] == ' ' ||
            s[index] == '\t' ||
            s[index] == valueSeparator ||
            s[index] == parameterSeparator) break;
        index++;
      }
      return s.substring(start, index);
    }

    void expect(String expected) {
      if (done() || s[index] != expected) {
        throw FormatException('Failed to parse header value');
      }
      index++;
    }

    void maybeExpect(String expected) {
      if (s[index] == expected) index++;
    }

    void parseParameters() {
      var parameters = <String, String?>{};
      _parameters = UnmodifiableMapView(parameters);

      String parseParameterName() {
        var start = index;
        while (!done()) {
          if (s[index] == ' ' ||
              s[index] == '\t' ||
              s[index] == '=' ||
              s[index] == parameterSeparator ||
              s[index] == valueSeparator) break;
          index++;
        }
        return s.substring(start, index).toLowerCase();
      }

      String? parseParameterValue() {
        if (!done() && s[index] == '"') {
          // Parse quoted value.
          var sb = StringBuffer();
          index++;
          while (!done()) {
            if (s[index] == '\\') {
              if (index + 1 == s.length) {
                throw FormatException('Failed to parse header value');
              }
              if (preserveBackslash && s[index + 1] != '"') {
                sb.write(s[index]);
              }
              index++;
            } else if (s[index] == '"') {
              index++;
              break;
            }
            sb.write(s[index]);
            index++;
          }
          return sb.toString();
        } else {
          // Parse non-quoted value.
          var val = parseValue();
          return val == '' ? null : val;
        }
      }

      while (!done()) {
        skipWS();
        if (done()) return;
        var name = parseParameterName();
        skipWS();
        if (done()) {
          parameters[name] = null;
          return;
        }
        maybeExpect('=');
        skipWS();
        if (done()) {
          parameters[name] = null;
          return;
        }
        var value = parseParameterValue();
        parameters[name] = value;
        skipWS();
        if (done()) return;
        if (s[index] == valueSeparator) return;
        expect(parameterSeparator);
      }
    }

    skipWS();
    _value = parseValue();
    skipWS();
    if (done()) return;
    maybeExpect(parameterSeparator);
    parseParameters();
  }
}

/// Representation of a header value in the form:
///
///   [:value; parameter1=value1; parameter2=value2:]
///
/// [HeaderValue] can be used to conveniently build and parse header
/// values on this form.
///
/// To build an [:accepts:] header with the value
///
///     text/plain; q=0.3, text/html
///
/// use code like this:
///
///     HttpClientRequest request = ...;
///     var v = new HeaderValue("text/plain", {"q": "0.3"});
///     request.headers.add(HttpHeaders.acceptHeader, v);
///     request.headers.add(HttpHeaders.acceptHeader, "text/html");
///
/// To parse the header values use the [:parse:] static method.
///
///     HttpRequest request = ...;
///     List<String> values = request.headers[HttpHeaders.acceptHeader];
///     values.forEach((value) {
///       HeaderValue v = HeaderValue.parse(value);
///     });
///
/// An instance of [HeaderValue] is immutable.
abstract class HeaderValue {
  /// Creates a new header value object setting the value and parameters.
  factory HeaderValue([String value = '', Map<String, String>? parameters]) {
    return _HeaderValue(value, parameters);
  }

  /// Creates a new cache-control header value object from parsing a header
  /// value string with both value and optional parameters.
  ///
  /// * [value]: The cache-control header directive
  ///
  /// Returns a [HeaderValue]
  static HeaderValue parseCacheControl(String value) {
    return HeaderValue.parse(
      'cache-control: $value',
      parameterSeparator: ',',
      valueSeparator: '=',
    );
  }

  /// Creates a new header value object from parsing a header value
  /// string with both value and optional parameters.
  ///
  /// * [value]: The header directive
  /// * [parameterSeparator]: The parameter separator, defaults to ';'
  /// * [valueSeparator]: The value separator
  /// * [preserveBackslash]: If the backslash should be preserved
  ///
  /// Returns a [HeaderValue]
  static HeaderValue parse(String value,
      {String parameterSeparator = ';',
      String? valueSeparator,
      bool preserveBackslash = false}) {
    return _HeaderValue.parse(value,
        parameterSeparator: parameterSeparator,
        valueSeparator: valueSeparator,
        preserveBackslash: preserveBackslash);
  }

  /// Gets the header value.
  String get value;

  /// Gets the map of parameters.
  ///
  /// This map cannot be modified. Invoking any operation which would
  /// modify the map will throw [UnsupportedError].
  Map<String, String?>? get parameters;

  /// Returns the formatted string representation in the form:
  ///
  ///     value; parameter1=value1; parameter2=value2
  @override
  String toString();
}
