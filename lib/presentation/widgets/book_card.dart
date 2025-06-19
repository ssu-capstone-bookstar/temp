import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  final String title;
  final String author;
  final String coverImageUrl;

  const BookCard({
    super.key,
    required this.title,
    required this.author,
    required this.coverImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    // Card 위젯은 앱 화면에서 정보를 담는 "카드" 형태의 시각적 요소를 만듭니다.
    // 보통 그림자 효과와 둥근 모서리를 가집니다.
    return Card(
      // elevation: 이 카드가 화면에서 얼마나 '떠 보이는지'를 나타내는 값입니다.
      // 값이 클수록 카드가 더 많이 떠 있는 것처럼 보이고, 그림자도 더 진하고 넓게 생깁니다.
      // 여기서는 4.0의 입체감을 주어 살짝 떠 있는 느낌을 줍니다.
      elevation: 4.0,
      // shape: 카드의 모양을 정의합니다. 여기서는 둥근 모서리를 설정했습니다.
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0), // 모든 모서리를 15.0만큼 둥글게 만듭니다.
      ),
      // child: Card 위젯 '안에' 어떤 내용을 넣을지 결정하는 속성입니다.
      // Card 위젯 자체는 빈 카드일 뿐이므로, 그 안에 실제 보여줄 내용을 child로 지정해줍니다.
      // 여기서는 여러 위젯을 세로로 배열하기 위해 'Column' 위젯을 child로 사용합니다.
      child: Column(
        // crossAxisAlignment.stretch: Column의 자식 위젯들이 가로 방향으로 최대한 늘어나게 합니다.
        // 예를 들어, 이미지가 카드 폭에 꽉 차게 보이도록 합니다.
        crossAxisAlignment: CrossAxisAlignment.stretch,
        // children: Column 위젯 안에 들어갈 '여러' 위젯들을 리스트 형태로 나열합니다.
        // 이미지, 제목, 저자, 좋아요 버튼 등 여러 요소를 담고 있습니다.
        children: <Widget>[
          // Expanded: Column이나 Row 위젯 안에서 남은 공간을 자식 위젯이 유연하게 채우도록 돕습니다.
          // flex: 3은 전체 남은 공간을 6등분했을 때, 이 이미지가 3/6 (즉 1/2)을 차지하라는 의미입니다.
          // 이미지와 아래 텍스트 영역이 3:3 비율로 공간을 나누어 가집니다.
          Expanded(
            flex: 3, // 이미지 부분을 전체 Card 높이의 약 절반 정도 차지하도록 설정
            child: ClipRRect(
              // ClipRRect: 모서리를 둥글게 잘라내는 위젯입니다.
              // 이미지가 카드 상단의 둥근 모서리에 맞춰 함께 둥글게 보이도록 합니다.
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15.0)),
              // Image.network: 인터넷에서 이미지를 가져와 표시하는 위젯입니다.
              child: Image.network(
                coverImageUrl, // 표시할 이미지의 URL 주소
                fit: BoxFit.cover, // 이미지가 주어진 공간을 꽉 채우도록 크기를 조절하되, 비율은 유지합니다.
                // loadingBuilder: 이미지가 로딩 중일 때 보여줄 위젯을 정의합니다.
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null)
                    return child; // 로딩이 완료되면 원래 이미지(child)를 보여줍니다.
                  return const Center(
                      child:
                          CircularProgressIndicator()); // 로딩 중에는 로딩 스피너를 보여줍니다.
                },
                // errorBuilder: 이미지 로딩에 실패했을 때 보여줄 위젯을 정의합니다.
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                      child: Icon(Icons.book,
                          size: 50, color: Colors.grey)); // 실패 시 책 아이콘을 보여줍니다.
                },
              ),
            ),
          ),
          // 아래쪽 텍스트 정보와 좋아요 버튼을 담는 Expanded 위젯입니다.
          Expanded(
            flex: 3, // 이 부분도 전체 Card 높이의 약 절반 정도를 차지하도록 설정
            child: Padding(
              // Padding: 자식 위젯 주변에 여백을 추가하는 위젯입니다.
              padding: const EdgeInsets.all(12.0), // 모든 방향으로 12.0만큼의 여백을 줍니다.
              child: Column(
                // Column: 다시 여러 위젯을 세로로 배열하기 위해 사용합니다.
                crossAxisAlignment:
                    CrossAxisAlignment.start, // 자식 위젯들을 왼쪽 정렬합니다.
                children: <Widget>[
                  Text(
                    // Text: 화면에 텍스트를 표시하는 위젯입니다.
                    title, // 책 제목 텍스트
                    style: const TextStyle(
                      // 텍스트의 스타일(폰트 크기, 굵기 등)을 정의합니다.
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2, // 텍스트가 표시될 최대 줄 수를 2줄로 제한합니다.
                    overflow: TextOverflow
                        .ellipsis, // 텍스트가 2줄을 넘어가면 ... (말줄임표)로 표시합니다.
                  ),
                  const SizedBox(
                      height:
                          4), // SizedBox: 특정 크기의 빈 공간을 만드는 위젯입니다. 텍스트 사이에 4만큼의 세로 간격을 줍니다.
                  Text(
                    author, // 저자 텍스트
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey[600], // 텍스트 색상을 회색으로 설정
                    ),
                    maxLines: 1, // 최대 1줄
                    overflow:
                        TextOverflow.ellipsis, // 1줄을 넘어가면 ... (말줄임표)로 표시합니다.
                  ),
                  // Align: 자식 위젯을 부모 위젯 내에서 특정 위치에 정렬하는 위젯입니다.
                  // 여기서는 좋아요 버튼을 오른쪽 아래로 정렬합니다.
                  Align(
                    alignment: Alignment.bottomRight, // 자식 위젯을 오른쪽 하단에 정렬
                    child: IconButton(
                      // IconButton: 클릭 가능한 아이콘 버튼을 만드는 위젯입니다.
                      padding: EdgeInsets
                          .zero, // 버튼 내부의 기본 패딩을 제거하여 아이콘이 차지하는 공간을 최소화합니다.
                      constraints:
                          const BoxConstraints(), // 버튼의 최소 크기 제약을 없애서 아이콘 크기만큼만 공간을 차지하게 합니다.
                      icon: const Icon(Icons.favorite_border), // 하트 모양의 아이콘
                      color: Colors.grey, // 아이콘 색상
                      onPressed: () {
                        // 버튼이 눌렸을 때 실행될 코드
                        // TODO: 좋아요 기능 구현 예정
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
