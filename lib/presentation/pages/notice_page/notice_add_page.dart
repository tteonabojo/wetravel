import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wetravel/core/constants/app_colors.dart'; // AppColors 정의 필요

class NoticeAddPage extends StatefulWidget {
  @override
  _NoticeAddPageState createState() => _NoticeAddPageState();
}

class _NoticeAddPageState extends State<NoticeAddPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveNoticeToFirestore() async {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('제목과 내용을 모두 입력해주세요.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      String title = _titleController.text;
      String content = _contentController.text;
      String date = '${_selectedDate.year}.${_selectedDate.month}.${_selectedDate.day}';

      await FirebaseFirestore.instance.collection('notices_test').add({
        'title': title,
        'content': content,
        'timestamp': Timestamp.fromDate(_selectedDate), // Timestamp로 저장
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('공지사항이 등록되었습니다.')),
      );

      Navigator.pop(context);
    } catch (error) {
      print('Error saving notice: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('공지 저장에 실패했습니다.')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('공지 추가')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextFieldWithLabel(
              label: '제목',
              controller: _titleController,
              hintText: '제목을 입력하세요',
            ),
            SizedBox(height: 20),
            _buildDateSelector(),
            SizedBox(height: 20),
            _buildContentTextField(),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Center(
                child: SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveNoticeToFirestore,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text('등록하기'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFieldWithLabel({
    required String label,
    required TextEditingController controller,
    required String hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.grayScale_650,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 8),
        Container(
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.grayScale_150),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Center(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: hintText,
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '날짜',
          style: TextStyle(
            color: AppColors.grayScale_650,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 8),
        GestureDetector(
          onTap: () => _selectDate(context),
          child: Container(
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.grayScale_150),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${_selectedDate.year}.${_selectedDate.month}.${_selectedDate.day}',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContentTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '내용',
          style: TextStyle(
            color: AppColors.grayScale_650,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 8),
        Container(
          height: 340,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.grayScale_150),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _contentController,
              expands: true,
              maxLines: null,
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                hintText: '내용을 입력하세요',
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
