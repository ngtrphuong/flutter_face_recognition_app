class Account {
  final String url;
  final int pk;
  final int empId;
  final String emailId;
  final String username;
  final String firstName;
  final String lastName;
  final String gender;
  final String phone;
  final bool readEmp;
  final bool addEmp;
  final bool readAtt;
  final bool addAtt;
  final bool readDept;
  final bool addDept;
  final String idType;
  final String idProof;
  final String profileImg;
  final int orgId;
  final int deptId;
  final String client;

  Account({
    this.url,
    this.pk,
    this.empId,
    this.emailId,
    this.username,
    this.firstName,
    this.lastName,
    this.gender,
    this.phone,
    this.readEmp,
    this.addEmp,
    this.readDept,
    this.addDept,
    this.readAtt,
    this.addAtt,
    this.idProof,
    this.idType,
    this.profileImg,
    this.orgId,
    this.deptId,
    this.client,
  });

  Map toJson() => {
        'url': url,
        'pk': pk,
        'empId': empId,
        'emailId': emailId,
        'username': username,
        'firstName': firstName,
        'lastName': lastName,
        'gender': gender,
        'phone': phone,
        'readEmp': readEmp,
        'addEmp': addEmp,
        'readAtt': readAtt,
        'addAtt': addAtt,
        'readDept': readDept,
        'addDept': addDept,
        'idProof': idProof,
        'idType': idType,
        'profileImg': profileImg,
        'orgId': orgId,
        'deptId': deptId,
        'client': client,
      };
}
