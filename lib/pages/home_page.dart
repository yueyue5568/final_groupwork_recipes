import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/meal_provider.dart';
import '../pages/meal_detail_page.dart';

// TODO: 组员A — 完善首页UI设计
// 当前只显示菜谱名称列表，需要完善：
// 1. 添加顶部分类筛选标签栏（横向滑动的category chips）  ✅ 完成
// 2. 优化列表项样式（添加图标、美化卡片外观）            ✅ 完成（彩色渐变卡片）
// 3. 添加下拉刷新功能                                  ✅ 完成
// 4. 添加搜索功能（按菜名搜索）                         ✅ 完成
// 5. 优化加载状态的显示（添加loading动画）              ✅ 完成

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _keyword = '';

  // 每个分类对应的 emoji（用于分类标签前缀）
  static const Map<String, String> _categoryEmoji = {
    '全部': '🍽️',
    '川菜': '🌶️',
    '粤菜': '🥘',
    '西餐': '🍝',
    '日料': '🍣',
    '甜品': '🍰',
    '汤品': '🍲',
    '素食': '🥗',
  };

  // 每个菜谱对应的 emoji（用于卡片头像）
  static const Map<String, String> _mealEmoji = {
    '麻婆豆腐': '🥘',
    '宫保鸡丁': '🍗',
    '白切鸡': '🍗',
    '番茄肉酱意面': '🍝',
    '寿司': '🍣',
    '提拉米苏': '🍰',
    '酸辣汤': '🍲',
  };

  // 根据菜名匹配 emoji（优先精确匹配，其次关键词匹配，最后默认 🍴）
  String _emojiForMeal(String name) {
    // 精确匹配
    final exact = {
      '麻婆豆腐': '🥘',
      '宫保鸡丁': '🍗',
      '白切鸡': '🍗',
      '番茄肉酱意面': '🍝',
      '寿司': '🍣',
      '提拉米苏': '🍰',
      '酸辣汤': '🍲',
      '红烧肉': '🥩',
      '鱼香肉丝': '🐟',
      '水煮鱼': '🐠',
      '小笼包': '🥟',
      '煎饺': '🥟',
      '春卷': '🌯',
      '锅包肉': '🍖',
      '北京烤鸭': '🦆',
      '回锅肉': '🥓',
      '东坡肉': '🥩',
      '糖醋里脊': '🍖',
      '酸辣土豆丝': '🥔',
      '蛋炒饭': '🍚',
      '扬州炒饭': '🍚',
      '拉面': '🍜',
      '兰州拉面': '🍜',
      '担担面': '🍜',
      '凉面': '🍝',
      '米线': '🍜',
      '酸辣粉': '🍜',
      '螺蛳粉': '🍜',
      '火锅': '🍲',
      '烧烤': '🍢',
      '披萨': '🍕',
      '汉堡': '🍔',
      '薯条': '🍟',
      '炸鸡': '🍗',
      '牛排': '🥩',
      '沙拉': '🥗',
      '三明治': '🥪',
      '热狗': '🌭',
      '蛋糕': '🍰',
      '冰淇淋': '🍦',
      '巧克力': '🍫',
      '饼干': '🍪',
      '面包': '🍞',
      '甜甜圈': '🍩',
      '奶茶': '🧋',
      '咖啡': '☕',
      '果汁': '🧃',
      '啤酒': '🍺',
      '红酒': '🍷',
      '茶': '🍵',
      '酸奶': '🥛',
      '汤': '🍲',
      '饺子': '🥟',
      '包子': '🥟',
      '馒头': '🍞',
      '粥': '🍚',
      '米饭': '🍚',
    };
    if (exact.containsKey(name)) return exact[name]!;

    // 关键词匹配（菜名包含关键词时使用对应 emoji）
    final keyword = {
      '豆腐': '🥘',
      '鸡': '🍗',
      '鸭': '🦆',
      '鱼': '🐟',
      '虾': '🦐',
      '蟹': '🦀',
      '肉': '🥩',
      '牛': '🥩',
      '猪': '🥓',
      '羊': '🍖',
      '蛋': '🥚',
      '菜': '🥬',
      '汤': '🍲',
      '面': '🍜',
      '饭': '🍚',
      '粥': '🍚',
      '饺': '🥟',
      '包': '🥟',
      '卷': '🌯',
      '饼': '🥞',
      '意': '🍝',
      '披萨': '🍕',
      '汉堡': '🍔',
      '薯': '🍟',
      '沙拉': '🥗',
      '甜': '🍰',
      '糖': '🍬',
      '冰': '🍦',
      '巧': '🍫',
      '奶': '🥛',
      '咖': '☕',
      '茶': '🍵',
      '酒': '🍺',
      '酸辣': '🌶️',
      '椒': '🌶️',
      '烧': '🍖',
      '烤': '🍢',
      '火': '🍲',
    };
    for (final entry in keyword.entries) {
      if (name.contains(entry.key)) return entry.value;
    }
    return '🍴';
  }

  // 通用 emoji 兜底（用于分类标签里没匹配的）
  String _emojiForCategory(String cat) {
    final map = {
      '全部': '🍽️',
      '川菜': '🌶️',
      '粤菜': '🥘',
      '西餐': '🍝',
      '日料': '🍣',
      '韩料': '🍱',
      '甜品': '🍰',
      '汤品': '🍲',
      '素食': '🥗',
      '小吃': '🥟',
      '主食': '🍚',
      '饮品': '🧋',
    };
    return map[cat] ?? '🍴';
  }

  // 卡片渐变色板（4 套颜色循环使用）
  static const List<List<Color>> _cardGradients = [
    [Color(0xFFFFE0B2), Color(0xFFFFCCBC)], // 橙粉
    [Color(0xFFC8E6C9), Color(0xFFB2DFDB)], // 绿青
    [Color(0xFFFFCCBC), Color(0xFFFFAB91)], // 橘红
    [Color(0xFFE1BEE7), Color(0xFFFFCDD2)], // 紫粉
    [Color(0xFFFFF9C4), Color(0xFFFFE0B2)], // 黄橙
    [Color(0xFFB3E5FC), Color(0xFFB2EBF2)], // 蓝青
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<MealProvider>().loadMeals());
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MealProvider>();

    return Scaffold(
      // 整个 body 用橙粉渐变背景，对照参考图
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFB088), Color(0xFFFFF3EE)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildSearchBar(),
              Expanded(child: _buildBody(provider)),
            ],
          ),
        ),
      ),
    );
  }

  // 顶部 AppBar：渐变橙色 + 美食菜谱标题 + 搜索图标
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Row(
        children: [
          const Text(
            '美食菜谱',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {
                // 搜索按钮逻辑（与搜索框同步）
              },
            ),
          ),
        ],
      ),
    );
  }

  // 搜索框：白底圆角，带搜索图标
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: _searchCtrl,
          onChanged: (val) {
            setState(() {
              _keyword = val.trim();
            });
          },
          decoration: InputDecoration(
            hintText: '搜索菜谱...',
            hintStyle: TextStyle(color: Colors.grey[400]),
            prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(MealProvider provider) {
    if (provider.isLoading) {
      return _buildLoading();
    }
    if (provider.errorMessage != null) {
      return _buildError(provider);
    }
    if (provider.meals.isEmpty) {
      return const Center(child: Text('暂无菜谱数据'));
    }
    return _buildContent(provider);
  }

  // ✅ 任务 4：带文字的 loading 动画
  Widget _buildLoading() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            color: Colors.deepOrange,
            strokeWidth: 3,
          ),
          SizedBox(height: 16),
          Text(
            '加载中...',
            style: TextStyle(
              color: Color(0xFF888888),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(MealProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(provider.errorMessage!),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => provider.loadMeals(),
            child: const Text('重新加载'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(MealProvider provider) {
    // 客户端按关键字过滤
    final filtered = _keyword.isEmpty
        ? provider.meals
        : provider.meals
            .where((m) => m.name.toLowerCase().contains(_keyword.toLowerCase()))
            .toList();

    return Column(
      children: [
        // ✅ 任务 1：分类标签栏（带 emoji + 渐变）
        _buildCategoryBar(provider),
        // 热门菜谱小标题
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
          child: Row(
            children: [
              const Text('🔥', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 6),
              const Text(
                '热门菜谱',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
        ),
        // ✅ 任务 2 + 3：渐变卡片 + 下拉刷新
        Expanded(
          child: RefreshIndicator(
            color: Colors.deepOrange,
            onRefresh: () async {
              await Future.delayed(const Duration(seconds: 1));
              await context.read<MealProvider>().loadMeals();
            },
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              itemCount: filtered.length,
              itemBuilder: (ctx, i) =>
                  _buildMealCard(ctx, provider, filtered[i], i),
            ),
          ),
        ),
      ],
    );
  }

  // ✅ 任务 1：分类筛选栏（横向滑动 + emoji + 渐变）
  Widget _buildCategoryBar(MealProvider provider) {
    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: provider.categories.length,
        itemBuilder: (ctx, i) {
          final cat = provider.categories[i];
          final selected = cat == provider.selectedCategory;
          final emoji = _emojiForCategory(cat);
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () {
                provider.filterByCategory(cat);
                setState(() => _keyword = '');
                _searchCtrl.clear();
              },
              borderRadius: BorderRadius.circular(22),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: selected
                      ? const LinearGradient(
                          colors: [Color(0xFFFF8A65), Color(0xFFFFAB91)],
                        )
                      : null,
                  color: selected ? null : Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: selected
                      ? [
                          BoxShadow(
                            color: Colors.deepOrange.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(emoji, style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 4),
                    Text(
                      cat,
                      style: TextStyle(
                        color: selected ? Colors.white : Colors.black87,
                        fontWeight:
                            selected ? FontWeight.bold : FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ✅ 任务 2：菜谱卡片（彩色渐变 + emoji 头像 + 标题/标签/时间 + 收藏）
  Widget _buildMealCard(
      BuildContext ctx, MealProvider provider, dynamic meal, int index) {
    final emoji = _emojiForMeal(meal.name);
    final gradient = _cardGradients[index % _cardGradients.length];
    final isFav = provider.isFavorite(meal.id);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              ctx,
              MaterialPageRoute(
                builder: (_) => MealDetailPage(meal: meal),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // 左侧渐变 emoji 头像
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: Text(emoji, style: const TextStyle(fontSize: 28)),
                ),
                const SizedBox(width: 12),
                // 中间：标题 + 标签 + 时间
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meal.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF333333),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          // 分类小标签
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFE0B2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              meal.category,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFFE65100),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              meal.area,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF888888),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(Icons.access_time,
                              size: 12, color: Color(0xFF888888)),
                          const SizedBox(width: 2),
                          Text(
                            '${meal.cookTime}分钟',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF888888),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // 右侧收藏按钮
                IconButton(
                  icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? Colors.redAccent : Colors.grey[400],
                    size: 22,
                  ),
                  onPressed: () {
                    if (isFav) {
                      provider.removeFavorite(meal.id);
                    } else {
                      provider.addFavorite(meal);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
