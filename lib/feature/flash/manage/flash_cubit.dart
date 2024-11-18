import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:torch_light/torch_light.dart'; // استيراد Timer

class FlashCubit extends Cubit<bool> {
  FlashCubit() : super(false); // الفلاش مغلق في البداية
  Timer? _timer;
  bool _isAutoToggleRunning = false; // حالة لتحديد ما إذا كان التبديل التلقائي قيد التشغيل

  // التبديل بين تشغيل وإيقاف الفلاش
  Future<void> toggleTorch() async {
    if (state) {
      await TorchLight.disableTorch();
    } else {
      await TorchLight.enableTorch();
    }
    emit(!state); // تغيير الحالة بعد التبديل
  }

  // بدء التبديل التلقائي كل ثانية
  void startAutoToggle() {
    if (_isAutoToggleRunning) {
      // إذا كان التبديل التلقائي قيد التشغيل بالفعل، لا نفعل شيئًا
      return;
    }
    _isAutoToggleRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      toggleTorch(); // يقوم بتبديل الفلاش كل ثانية
    });
  }

  // إيقاف التبديل التلقائي
  void stopAutoToggle() {
    _timer?.cancel();
    _timer = null;
    _isAutoToggleRunning = false; // تغيير حالة التبديل التلقائي
  }

  // التبديل بين تشغيل وإيقاف التبديل التلقائي
  void toggleAutoToggle() {
    if (_isAutoToggleRunning) {
      stopAutoToggle(); // إذا كان التبديل التلقائي قيد التشغيل، قم بإيقافه
    } else {
      startAutoToggle(); // إذا كان متوقفًا، قم بتشغيله
    }
  }

  bool get isAutoToggleRunning => _isAutoToggleRunning; // الحصول على حالة التبديل التلقائي
}

