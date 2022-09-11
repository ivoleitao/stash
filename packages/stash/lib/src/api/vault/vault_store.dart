import '../store.dart';
import 'vault_entry.dart';
import 'vault_info.dart';

// Vault store marker interface
abstract class VaultStore extends Store<VaultInfo, VaultEntry> {}
