class UserAddress {
  String id = '-1';
  String ip = '';

  UserAddress(this.id, this.ip);

  UserAddress.empty() {
    this.id = '-1';
    this.ip = '';
  }
}
