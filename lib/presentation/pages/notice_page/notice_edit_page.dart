import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wetravel/core/constants/app_colors.dart';

class NoticeEditPage extends StatefulWidget {
  final Map<String, dynamic> noticeData;
  final String noticeId;

  const NoticeEditPage({Key? key, required this.noticeData, required this.noticeId})
      : super(key: key);

  @override
  _NoticeEditPageState createState() => _NoticeEditPageState();
}

class _NoticeEditPageState extends State<NoticeEditPage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController; // 내용 컨트롤러 추가
  DateTime? _selectedDate; // 날짜를 String 에서 Date으로 변경

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.noticeData['title']);
    _contentController = TextEditingController(text: widget.noticeData['content'] ?? '');

    // Firestore에서 가쟈온 Timestamp 값을 DateTime으로 변환
    Timestamp? timestamp = widget.noticeData['date'] as Timestamp?;
    _selectedDate = timestamp?.toDate();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose(); // 내용 컨트롤러 dispose
    super.dispose();
  }

  // 날짜 선택 다이얼로그
  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(()  {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('공지사항 수정'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('notices_test')
                  .doc(widget.noticeId)
                  .update({
                'title': _titleController.text,
                'date': _selectedDate != null ? Timestamp.fromDate(_selectedDate!) : null,
                'content': _contentController.text,
              });
              Navigator.pop(context);
            },
            child: const Text(
              '저장',
              style: TextStyle(color: AppColors.primary_450),
            ),
          ),
        ],

      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.grayScale_250),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      hintText: '제목',
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _pickDate,
                    child: AbsorbPointer(
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: '날짜 선택',
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        controller: TextEditingController(
                          text: _selectedDate != null ? DateFormat('yyyy-MM-dd').format(_selectedDate!) : '',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded( // 남은 공간을 모두 차지하도록 Expanded 추가
              child: TextFormField(
                controller: _contentController,
                expands: true, // 내용이 여러 줄에 걸쳐 입력될 수 있도록 expands: true
                maxLines: null, // 내용이 무제한으로 입력될 수 있도록 maxLines: null
                decoration: const InputDecoration(
                  hintText: '내용',
                  border: InputBorder.none,
                ),
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
                textAlignVertical: TextAlignVertical.top, // 텍스트를 위쪽 정렬
              ),
            ),
          ],
        ),
      ),
    );
  }
}