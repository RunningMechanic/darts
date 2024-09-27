import 'dart:io';

Future<String?> getIp() async {
  for (final interface in await NetworkInterface.list()) {
    for (final address in interface.addresses) {
      if (!address.isLinkLocal && !address.isLoopback && !address.isMulticast) {
        return address.address;
      }
    }
  }
  return null;
}
