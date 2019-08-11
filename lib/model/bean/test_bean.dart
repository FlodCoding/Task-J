class TestBean {
	String shapeName;
	TestProperty property;

	TestBean({this.shapeName, this.property});

	TestBean.fromJson(Map<String, dynamic> json) {
		shapeName = json['shape_name'];
		property = json['property'] != null ? new TestProperty.fromJson(json['property']) : null;
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['shape_name'] = this.shapeName;
		if (this.property != null) {
      data['property'] = this.property.toJson();
    }
		return data;
	}
}

class TestProperty {
	double breadth;
	double width;

	TestProperty({this.breadth, this.width});

	TestProperty.fromJson(Map<String, dynamic> json) {
		breadth = json['breadth'];
		width = json['width'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['breadth'] = this.breadth;
		data['width'] = this.width;
		return data;
	}
}
