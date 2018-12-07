
String groupinEng(String group){

  switch(group){
    case '한동대학교':
      return 'Handong';
      break;
    case '포항공과대학교' :
      return 'Postech';
      break;
    case '선린대학교' :
      return 'Sunlin';
      break;
  }
}

String categoryKOR(String category){

  switch(category){
    case 'book':
      return '책';
      break;
    case 'utility' :
      return '생활용품';
      break;
    case 'clothes' :
      return '의류 및 잡화';
      break;
    case 'furniture' :
      return '가전 및 가구';
      break;
    case 'other' :
      return '기타';
      break;
    case 'house' :
      return '부동산';
      break;
  }

}