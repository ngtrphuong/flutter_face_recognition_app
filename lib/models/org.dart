class Organization {
  final String url;
  final int pk;
  final String name;
  final String orgType;
  final String contact;
  final int staffcount;
  final String logo;

  Organization({
    this.url,
    this.pk,
    this.name,
    this.orgType,
    this.contact,
    this.staffcount,
    this.logo,
  });

  Map toJson() => {
        'url': url,
        'pk': pk,
        'name': name,
        'orgType': orgType,
        'contact': contact,
        'staffcount': staffcount,
        'logo': logo,
      };
}
