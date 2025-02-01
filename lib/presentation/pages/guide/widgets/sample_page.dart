import 'package:flutter/material.dart';
import 'package:wetravel/core/constants/app_shadow.dart';

class SamplePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(color: Colors.amber),
          width: 343,
          height: 713,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 160,
                padding: const EdgeInsets.all(16),
                decoration: ShapeDecoration(
                  color: Colors.red,
                  shape: RoundedRectangleBorder(),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 28,
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      height: 24,
                                      child: Text(
                                          '황거 앞 흑송 2000그루의 잔디밭 광장(국민공원)을 둘러봅니다. 에도시대 지방영주들의 저택이 있었던 곳 입니다. 니쥬바시에서 왼쪽편에 있는 문으로 벗꽃이 많아 사쿠라다몬으로 불리워 진 곳입니다.'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 232,
                padding: const EdgeInsets.all(16),
                decoration: ShapeDecoration(
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  shadows: AppShadow.generalShadow,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 100,
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      child: Text(
                                          '황거 앞 흑송 2000그루의 잔디밭 광장(국민공원)을 둘러봅니다. 에도시대 지방영주들의 저택이 있었던 곳 입니다. 니쥬바시에서 왼쪽편에 있는 문으로 벗꽃이 많아 사쿠라다몬으로 불리워 진 곳입니다.'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
