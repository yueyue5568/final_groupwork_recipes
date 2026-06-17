import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

/// 关于/合规页 — 组员E完成
/// 包含：暗色模式切换 + 隐私政策 + 合规声明 + 思政总结
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('关于与设置'),
        centerTitle: true,
        actions: [
          // 快捷暗色模式切换按钮（AppBar右上角）
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              color: isDark ? Colors.orangeAccent : Colors.amber,
            ),
            onPressed: () => themeProvider.toggleTheme(),
            tooltip: '切换主题',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ─── 应用信息卡片 ───
          _buildAppInfoCard(isDark),
          const SizedBox(height: 16),

          // ─── 暗色模式切换 ───
          _buildThemeSwitchCard(context, themeProvider, isDark),
          const SizedBox(height: 16),

          // ─── 隐私政策 ───
          _buildPrivacyCard(isDark),
          const SizedBox(height: 16),

          // ─── 合规/开源声明 ───
          _buildComplianceCard(isDark),
          const SizedBox(height: 16),

          // ─── 数据来源说明 ───
          _buildDataSourceCard(isDark),
          const SizedBox(height: 16),

          // ─── 小组分工信息 ───
          _buildTeamCard(isDark),
          const SizedBox(height: 16),

          // ─── 思政总结 ───
          _buildIdeologyCard(isDark),
          const SizedBox(height: 24),

          // ─── 版权信息 ───
          _buildCopyright(isDark),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════
  // 应用信息卡片
  // ════════════════════════════════════════════════════════
  Widget _buildAppInfoCard(bool isDark) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              Icons.restaurant_menu,
              size: 64,
              color: isDark ? Colors.orangeAccent : Colors.deepOrange,
            ),
            const SizedBox(height: 12),
            Text(
              '美食菜谱',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: isDark ? Colors.orange.withValues(alpha: 0.15) : Colors.orange.shade50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? Colors.orangeAccent : Colors.orange.shade200,
                  width: 1,
                ),
              ),
              child: Text(
                'v1.0.0',
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.orangeAccent : Colors.deepOrange,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '一款基于 Flutter 开发的美食菜谱应用，\n'
              '提供菜谱浏览、分类筛选、收藏管理等功能。',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════
  // 暗色模式切换卡片
  // ════════════════════════════════════════════════════════
  Widget _buildThemeSwitchCard(BuildContext context, ThemeProvider provider, bool isDark) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
        leading: CircleAvatar(
          backgroundColor: isDark ? Colors.blueGrey.shade800 : Colors.amber.shade100,
          child: Icon(
            isDark ? Icons.dark_mode : Icons.light_mode,
            color: isDark ? Colors.orangeAccent : Colors.amber.shade700,
          ),
        ),
        title: const Text(
          '暗色模式',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          isDark ? '当前：深色主题' : '当前：浅色主题',
          style: TextStyle(fontSize: 13, color: isDark ? Colors.grey[400] : Colors.grey[600]),
        ),
        trailing: Switch(
          value: isDark,
          onChanged: (value) => provider.setDarkMode(value),
          thumbColor: WidgetStateProperty.resolveWith((states) => Colors.orangeAccent),
          trackColor: WidgetStateProperty.resolveWith((states) => states.contains(WidgetState.selected) ? Colors.orange.shade200 : null),
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════
  // 隐私政策卡片
  // ════════════════════════════════════════════════════════
  Widget _buildPrivacyCard(bool isDark) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ExpansionTile(
        leading: Icon(Icons.privacy_tip_outlined, color: Colors.blue.shade600),
        title: const Text(
          '隐私政策',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '了解我们如何保护您的隐私',
          style: TextStyle(fontSize: 12, color: isDark ? Colors.grey[400] : Colors.grey[500]),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(56, 0, 16, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _privacyItem('📋 数据收集', '本应用不收集、存储或传输任何用户的个人身份信息（如姓名、手机号、身份证号等）。', isDark),
                const SizedBox(height: 10),
                _privacyItem('💾 本地存储', '用户收藏的菜谱信息仅保存在设备本地（SharedPreferences），不会上传至任何服务器。', isDark),
                const SizedBox(height: 10),
                _privacyItem('🌐 网络请求', '应用仅在启动时通过 Dio 从 Gitee 远程仓库加载公开的菜谱 JSON 数据，不涉及用户隐私。', isDark),
                const SizedBox(height: 10),
                _privacyItem('🔒 权限声明', '本应用不申请任何敏感权限，无需摄像头、麦克风、位置、通讯录等授权。', isDark),
                const SizedBox(height: 10),
                _privacyItem('📅 更新时间', '2026年6月', isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 隐私政策条目组件
  Widget _privacyItem(String title, String desc, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$title ',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
                TextSpan(
                  text: desc,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.grey[400] : Colors.grey[700],
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ════════════════════════════════════════════════════════
  // 合规/开源声明卡片
  // ════════════════════════════════════════════════════════
  Widget _buildComplianceCard(bool isDark) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ExpansionTile(
        leading: Icon(Icons.balance_outlined, color: Colors.green.shade600),
        title: const Text(
          '开源合规声明',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '开源协议与项目引用说明',
          style: TextStyle(fontSize: 12, color: isDark ? Colors.grey[400] : Colors.grey[500]),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(56, 0, 16, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _complianceText(
                  '本项目在架构设计和功能规划上参考了以下开源项目：',
                  isDark,
                  bold: false,
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey.shade800 : Colors.green.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isDark ? Colors.green.shade300 : Colors.green.shade200,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '📦 参考项目：recipes',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isDark ? Colors.white : Colors.black87),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '地址：gitee.com/coder-YsH/recipes\n'
                        '协议：MIT License',
                        style: TextStyle(fontSize: 13, color: isDark ? Colors.grey[300] : Colors.grey[700], height: 1.5),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _complianceText(
                  '本项目所有业务逻辑代码均为团队自主开发，UI 设计和功能实现均经过独立设计与编码。参考开源项目仅用于学习其数据模型与页面结构设计思路。',
                  isDark,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _complianceText(String text, bool isDark, {bool bold = true}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        color: isDark ? Colors.grey[300] : Colors.grey[700],
        height: 1.5,
        fontWeight: bold ? FontWeight.w500 : FontWeight.normal,
      ),
    );
  }

  // ════════════════════════════════════════════════════════
  // 数据来源说明卡片
  // ════════════════════════════════════════════════════════
  Widget _buildDataSourceCard(bool isDark) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
        leading: Icon(Icons.cloud_download_outlined, color: Colors.teal.shade600),
        title: const Text(
          '数据来源',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '本应用菜谱数据通过 Dio 从 Gitee 远程仓库加载，数据来源合法合规。\n'
          '如遇网络异常，将自动使用本地 data/meals.json 备份数据。',
          style: TextStyle(fontSize: 13, color: isDark ? Colors.grey[400] : Colors.grey[600], height: 1.4),
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════
  // 小组分工卡片
  // ════════════════════════════════════════════════════════
  Widget _buildTeamCard(bool isDark) {
    final members = [
      {'role': '组长', 'name': '王怡婷', 'task': '项目搭建 + 远程数据加载 + 状态管理'},
      {'role': '组员A', 'name': '廖春花', 'task': '完善首页UI'},
      {'role': '组员B', 'name': '周伟佳', 'task': '完善详情页 + 烹饪计时器'},
      {'role': '组员C', 'name': '陈嘉玲', 'task': '收藏功能 + 本地持久化'},
      {'role': '组员D', 'name': '岳沛珂', 'task': '完善搜索页 + 食材反搜'},
      {'role': '组员E', 'name': '杨美媛', 'task': '暗色模式 + 关于/合规页'},
      {'role': '组员F', 'name': '杨顺粉', 'task': '扩充数据 + 真机运行测试'},
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ExpansionTile(
        leading: Icon(Icons.group_outlined, color: Colors.purple.shade600),
        title: const Text(
          '小组分工',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '7人团队 · 移动应用开发实训',
          style: TextStyle(fontSize: 12, color: isDark ? Colors.grey[400] : Colors.grey[500]),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: members.map((m) {
                final isMe = m['name'] == '杨美媛';
                return Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: isMe
                        ? (isDark ? Colors.purple.shade300.withValues(alpha: 0.2) : Colors.purple.shade50)
                        : (isDark ? Colors.grey.shade800 : Colors.grey.shade50),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isMe
                          ? (isDark ? Colors.purple.shade300 : Colors.purple.shade200)
                          : (isDark ? Colors.grey.shade700 : Colors.grey.shade200),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: isMe
                              ? (Colors.purple)
                              : (isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          m['role']!.replaceFirst('组员', '').replaceFirst('组长', '长'),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${m['role']}${m['name']!.isNotEmpty ? ' · ${m['name']}' : ''}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: isMe ? FontWeight.bold : FontWeight.w500,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                            Text(
                              m['task']!,
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? Colors.grey[400] : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isMe)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.purple,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            '我',
                            style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════
  // 思政总结卡片
  // ════════════════════════════════════════════════════════
  Widget _buildIdeologyCard(bool isDark) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: isDark ? Colors.red.shade300 : Colors.red.shade200,
          width: 1,
        ),
      ),
      color: isDark ? Colors.red.shade900.withValues(alpha: 0.25) : Colors.red.shade50,
      child: ExpansionTile(
        leading: Icon(Icons.auto_stories_rounded, color: Colors.red.shade700),
        title: const Text(
          '课程思政总结',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '实践育人 · 技术报国',
          style: TextStyle(fontSize: 12, color: Colors.red.shade400),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ideologySectionTitle('一、工匠精神的体现', isDark),
                const SizedBox(height: 6),
                _ideologyBody(
                  '在本次移动应用开发实训中，我们从零开始搭建一个完整的美食菜谱应用，经历了需求分析、UI设计、功能实现、联调测试等多个环节。每一个细节的打磨——从首页分类标签的美化到烹饪计时器的精确实现——都体现了精益求精的工匠精神。作为计算机专业学生，我们深知一行行代码承载的是对用户体验的责任感。',
                  isDark,
                ),

                const SizedBox(height: 14),
                _ideologySectionTitle('二、团队协作的力量', isDark),
                const SizedBox(height: 6),
                _ideologyBody(
                  '本项目由7名组员分工协作完成，涵盖了前端UI设计、状态管理、本地持久化、搜索算法、暗色模式适配等多方面工作。通过合理分工和密切配合，我们深刻体会到了"众人拾柴火焰高"的道理。在实际开发过程中，我们学会了沟通、妥协与相互支持，这正是未来职场工作中不可或缺的核心能力。',
                  isDark,
                ),

                const SizedBox(height: 14),
                _ideologySectionTitle('三、技术自信与创新意识', isDark),
                const SizedBox(height: 6),
                _ideologyBody(
                  '本项目采用 Google 的 Flutter 跨平台框架进行开发，使用 Dart 语言编写代码，结合 Provider 进行状态管理，利用 SharedPreferences 实现本地持久化。这些技术选型体现了我们对国产化替代方案的积极探索。同时，我们在参考开源项目的基础上进行了独立创新，实现了符合中国用户审美和使用习惯的界面设计。',
                  isDark,
                ),

                const SizedBox(height: 14),
                _ideologySectionTitle('四、服务社会的理念', isDark),
                const SizedBox(height: 6),
                _ideologyBody(
                  '美食是中华文化的重要组成部分。我们希望通过这个小小的应用，让更多人感受到中华饮食文化的魅力，同时也传递健康生活的理念。作为新时代的大学生，我们将所学知识转化为实际成果，服务于社会大众，这正是"学以致用、知行合一"的最好体现。',
                  isDark,
                ),

                const SizedBox(height: 14),
                _ideologySectionTitle('五、总结与展望', isDark),
                const SizedBox(height: 6),
                _ideologyBody(
                  '本次实训让我们深刻认识到，移动应用开发不仅是一项技术活，更是一门综合性的学问。它要求我们具备扎实的技术功底、良好的审美素养、严谨的逻辑思维以及强烈的社会责任感。我们将以此次实践为起点，继续努力学习专业知识，用技术创造价值，为建设网络强国贡献青春力量！',
                  isDark,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _ideologySectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.red.shade300 : Colors.red.shade800,
      ),
    );
  }

  Widget _ideologyBody(String text, bool isDark) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        color: isDark ? Colors.grey[400] : Colors.grey[700],
        height: 1.7,
      ),
    );
  }

  // ════════════════════════════════════════════════════════
  // 底部版权信息
  // ════════════════════════════════════════════════════════
  Widget _buildCopyright(bool isDark) {
    return Center(
      child: Column(
        children: [
          Divider(color: isDark ? Colors.grey[700] : Colors.grey[300]),
          const SizedBox(height: 8),
          Text(
            '云南大学 信息学院',
            style: TextStyle(fontSize: 13, color: isDark ? Colors.grey[400] : Colors.grey[600]),
          ),
          Text(
            '移动应用软件开发实训 · 2026春季学期',
            style: TextStyle(fontSize: 12, color: isDark ? Colors.grey[500] : Colors.grey[500]),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}