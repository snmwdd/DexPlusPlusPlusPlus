-- Dex# localization: UI and optional property labels; instance/API data stays unchanged.
local Main, Settings, Apps
local function initDeps(data) Main, Settings, Apps=data.Main,data.Settings,data.Apps end
local zh = {
    ["3D Preview"]="3D 预览",
    ["Basic Colors"]="基本颜色",
    ["Blue:"]="蓝：",
    ["ColorSequence Color Picker"]="颜色序列选择器",
    ["Custom Colors (RC = Set)"]="自定义颜色（右键设置）",
    ["Green:"]="绿：",
    ["Hue:"]="色相：",
    ["More Colors"]="更多颜色",
    ["Name"]="名称",
    ["Objects"]="对象",
    ["Red:"]="红：",
    ["Sat:"]="饱和度：",
    ["Save Instance - Error"]="保存实例 - 错误",
    ["Save Instance - Saved"]="保存实例 - 已保存",
    ["Save Instance - Saving"]="保存实例 - 正在保存",
    ["Decompile Scripts"]="反编脚本",
    ["Decompile Timeout (s)"]="反编超时（秒）",
    ["Decompiler Max Threads"]="反编最大线程数",
    ["Decompile Ignore"]="反编忽略列表",
    ["Save Nil Instances"]="保存无父级实例",
    ["Remove Player Characters"]="移除玩家角色",
    ["Save Player Instance"]="保存玩家实例",
    ["Isolate StarterPlayer"]="单独保存初始玩家配置",
    ["Ignore Default Properties"]="忽略默认属性",
    ["Show Status"]="显示状态",
    ["Type"]="类型",
    ["Val:"]="亮度：",
    ["Window"]="窗口",
    ["Your executor does not support 'writefile'"]="执行器不支持 writefile",
    ["[SETTING: OFF]"]="[设置：关闭]",
    ["[SETTING: ON]"]="[设置：开启]",
    ["- Select -"]="- 请选择 -",
    ["Error: Name begins with 'RBX'"]="错误：名称不能以 RBX 开头",
    ["Error: Name over 100 chars"]="错误：名称超过 100 字符",
    ["Failed to view model: No PrimaryPart is found."]="无法预览模型：未找到 PrimaryPart。",
    ["Language"]="语言",
    ["Translate Properties"]="翻译属性",
    ["File Manager"]="文件管理器",
    ["Cobalt Spy"]="spy",
    ["Spy Settings"]="Spy 设置",
    ["Search Calls"]="搜索调用",
    ["Remote Details"]="远程对象详情",
    ["Spy Plugins"]="Spy 插件",
    ["Hide Spy Window"]="隐藏 Spy 窗口",
    ["Stop and Unload Spy"]="停止捕获并卸载 Spy",
    ["deivid, upio (Cobalt Spy)"]="deivid、upio（Cobalt Spy 原作者）",
    ["Cobalt authors: deivid, upio"]="Cobalt 原作者：deivid、upio",
    ["Loading spy"]="加载 spy",
    ["Spy could not start. Reload Dex to retry."]="spy 启动失败，请重新加载 Dex 重试。",
    ["Another Cobalt instance is already running. Unload it before starting Dex Spy."]="已有另一个 Cobalt 正在运行，请先卸载它再启动 Dex Spy。",
    ["Workspace Files"]="Workspace 文件",
    ["Game Resources"]="游戏资源",
    ["All Resources"]="全部资源",
    ["Images and Textures"]="图片和贴图",
    ["Models"]="模型",
    ["Copy Resource ID"]="复制资源 ID / 路径",
    ["Locate in Explorer"]="定位到资源列表",
    ["Export Model"]="导出模型",
    ["Apply Asset ID"]="应用资源 ID",
    ["Asset ID or path"]="资源 ID 或路径",
    ["Search resources or asset IDs"]="搜索资源或资源 ID",
    ["Scanning game resources"]="正在扫描游戏资源",
    ["Cannot scan game resources"]="无法扫描游戏资源",
    ["Resource scan cancelled"]="资源扫描已取消",
    ["Resource is no longer available"]="资源已不存在或不可访问",
    ["Invalid asset ID or path"]="资源 ID 或路径无效",
    ["Cannot edit this resource"]="无法修改此资源",
    ["Clipboard is unavailable"]="剪贴板不可用",
    ["Copied resource ID or path"]="已复制资源 ID 或路径",
    ["Resource located in Explorer"]="已定位到资源列表",
    ["Resource updated"]="资源已更新",
    ["Select a model to export"]="请选择要导出的模型",
    ["Model exported"]="模型已导出",
    ["Model preview unavailable"]="此模型暂时无法预览",
    ["Clear this asset reference?"]="清除此资源引用？",
    ["Delete this model from the current game?"]="从当前游戏中删除此模型？",
    ["Up"]="上一级",
    ["New File"]="新建文件",
    ["New Folder"]="新建文件夹",
    ["Create"]="创建",
    ["Search files"]="搜索文件",
    ["File or folder name"]="文件或文件夹名称",
    ["Select a text file to preview or edit"]="选择文本文件以预览或编辑",
    ["Folder is empty"]="文件夹为空",
    ["Folder selected; click Open to enter"]="已选择文件夹，点击打开进入",
    ["Open"]="打开",
    ["File saved"]="文件已保存",
    ["Unsaved Changes"]="未保存的修改",
    ["Discard unsaved changes?"]="放弃未保存的修改？",
    ["Delete this file?"]="删除此文件？",
    ["Delete this folder and all its contents?"]="删除此文件夹及其全部内容？",
    ["File operation unavailable"]="当前执行器不支持此文件操作",
    ["File operation failed"]="文件操作失败",
    ["Cannot read folder"]="无法读取文件夹",
    ["Cannot read file"]="无法读取文件",
    ["Invalid path"]="路径无效",
    ["Invalid file or folder name"]="文件或文件夹名称无效",
    ["A file or folder with that name already exists"]="已存在同名文件或文件夹",
    ["Text preview limit is 256 KB"]="文本预览上限为 256 KB",
    ["This file cannot be edited as text"]="此文件无法作为文本编辑",
    ["Settings"]="设置",
    ["Settings - Saving"]="设置 - 正在保存",
    ["Settings - Saved"]="设置 - 已保存",
    ["Explorer"]="资源列表",
    ["Properties"]="属性",
    ["Notepad"]="脚本编辑器",
    ["Console"]="控制台",
    ["Save Instance"]="保存实例",
    ["3D Viewer"]="3D 查看器",
    ["Click part to select"]="点击选择零件",
    ["Click gui to select"]="点击选择 GUI",
    ["Close"]="关闭",
    ["Move"]="移动",
    ["Scale"]="缩放",
    ["Rotate"]="旋转",
    ["UI"]="界面",
    ["Window Title On Middle"]="窗口标题居中",
    ["Background Transparency"]="背景透明度",
    ["Class Icons"]="类图标",
    ["Click to Rename"]="点击重命名",
    ["Part Selection Box"]="零件选择框",
    ["Use GetChildren to Copy Path"]="使用 GetChildren 复制路径",
    ["Show Deprecated"]="显示弃用属性",
    ["Show Hidden"]="显示隐藏属性",
    ["Show Attributes"]="显示属性标记",
    ["Clear On Focus"]="获得焦点时清空",
    ["Script Viewer"]="脚本查看器",
    ["Show Decompiled Script Info"]="显示反编译脚本信息",
    ["Decompiler"]="反编译器",
    ["Deobf Mode"]="反编译模式",
    ["Select a decompiler for View Script."]="选择查看脚本时使用的反编译器。",
    ["Non-Executor modes require getscriptbytecode."]="非 Executor 模式需要 getscriptbytecode。",
    ["Shiny Decompiler Port"]="Shiny 反编译器端口",
    ["Prefer Fallback Decompiler"]="优先使用备用反编译器",
    ["Restart"]="重启",
    ["Apply Current Settings"]="应用当前设置",
    ["By applying current settings requires reload.\nAny unsaved progress will be lost.\nAre you sure?"]="应用这些设置需要重新加载。\n未保存的内容将丢失。\n确定继续？",
    ["Apply Later"]="稍后应用",
    ["Apply Now"]="立即应用",
    ["Copy"]="复制",
    ["Copy to Clipboard"]="复制到剪贴板",
    ["Save"]="保存",
    ["Save to File"]="保存到文件",
    ["Dump Functions"]="导出函数",
    ["Execute"]="执行",
    ["Clear"]="清空",
    ["Re-Deobf"]="重新反编译",
    ["Cancel"]="取消",
    ["OK"]="确定",
    ["Yes"]="是",
    ["No"]="否",
    ["Reset"]="重置",
    ["Delete"]="删除",
    ["Cut"]="剪切",
    ["Paste"]="粘贴",
    ["Duplicate"]="复制实例",
    ["Rename"]="重命名",
    ["Group"]="分组",
    ["Ungroup"]="取消分组",
    ["Select Children"]="选择子项",
    ["Jump to Parent"]="跳到父级",
    ["Copy Path"]="复制路径",
    ["View Script"]="查看脚本",
    ["Save As"]="另存为",
    ["Color Picker"]="颜色选择器",
    ["NumberSequence Editor"]="数字序列编辑器",
    ["ColorSequence Editor"]="颜色序列编辑器",
    ["Search"]="搜索",
    ["Search workspace"]="搜索资源列表",
    ["Search properties"]="搜索属性",
    ["Filter"]="筛选",
    ["Refresh"]="刷新",
    ["Expand All"]="全部展开",
    ["Collapse All"]="全部折叠",
    ["Insert Object"]="插入对象",
    ["Insert Part"]="插入零件",
    ["Teleport To"]="传送至",
    ["Ultimate Debugging Suite"]="全功能调试工具",
    ["Contributors >>"]="开发者 >>",
    ["Toon (IY Dex and PRs)"]="Toon（IY Dex 与贡献）",
    ["Moon (Dex)"]="Moon（Dex）",
    ["Cazan (3D Preview)"]="Cazan（3D 预览）",
    ["Chillz (Original Dex)"]="Chillz（原版 Dex）",
    ["Gpt6.1 (Dex#)"]="Gpt6.1（Dex#）",
    ["Running"]="运行中",
    ["Initializing Library"]="初始化界面库",
    ["Fetching Roblox Version"]="获取 Roblox 版本",
    ["Fetching API"]="获取 API",
    ["Loading Modules"]="加载模块",
    ["Initializing Apps"]="初始化应用",
    ["Loading Plugin Files"]="加载插件文件",
    ["Complete"]="完成",
    ["Cannot edit this object"]="无法编辑此对象",
    ["Layout controls position"]="布局控制位置",
    ["Grid layout controls size"]="网格布局控制尺寸",
    ["AutomaticSize controls size"]="AutomaticSize 控制尺寸",
    ["Auto Scroll"]="自动滚动",
    ["AutoScroll"]="自动滚动",
    ["Find"]="查找",
    ["Replace"]="替换",
    ["Find Next"]="查找下一个",
    ["Remove Attribute"]="移除属性",
    ["Add Attribute"]="添加属性",
    ["Name:"]="名称：",
    ["Filename:"]="文件名：",
    ["File Name"]="文件名",
    ["Save Selected"]="保存选中对象",
    ["Save All"]="保存全部",
    ["Output"]="输出",
    ["Time"]="时间",
    ["Value"]="数值",
    ["Color"]="颜色",
    ["Envelope"]="范围",
}
-- Separate dictionaries avoid translating instance values or confusing a property
-- with a category of the same name (for example, Localization).
local propertyZh = {
    -- Instance, services and players (including hidden/deprecated labels).
    Name="名称", Parent="父级", ClassName="类名", className="类名",
    Archivable="可存档", UniqueId="唯一标识", HistoryId="历史标识",
    SourceAssetId="源资源 ID", Capabilities="权限能力", Sandboxed="沙盒模式",
    DefinesCapabilities="定义权限能力", Tags="标签", Attributes="自定义属性",
    Use2022Materials="使用 2022 版材质", MaterialVariant="材质变体",
    AccountAge="账号年龄", AgeChecked="年龄验证状态", AutoJumpEnabled="自动跳跃",
    BubbleChat="气泡聊天", Character="角色", CharacterAppearance="角色外观",
    CharacterAppearanceId="角色外观 ID", ClassicChat="经典聊天",
    DisplayName="显示名称", FollowUserId="跟随用户 ID",
    FrustumStreaming="视锥流式加载", HasRobloxSubscription="拥有 Roblox 订阅",
    HasVerifiedBadge="拥有认证徽章", InputLatency="输入延迟", LocalPlayer="本地玩家",
    MaxPlayers="最大玩家数", MembershipType="会员类型", NumPlayers="玩家数量",
    PreferredPlayers="建议玩家数", RespawnLocation="重生位置", Team="队伍",
    TeamColor="队伍颜色", Neutral="中立", UserId="用户 ID",
    CameraMode="摄像机模式", CameraMaxZoomDistance="摄像机最大缩放距离",
    CameraMinZoomDistance="摄像机最小缩放距离", DevCameraOcclusionMode="摄像机遮挡模式",
    DevComputerCameraMode="电脑摄像机模式", DevComputerMovementMode="电脑移动模式",
    DevTouchCameraMode="触屏摄像机模式", DevTouchMovementMode="触屏移动模式",
    DevEnableMouseLock="允许鼠标锁定", AutoLoads="自动加载",
    CharacterAutoLoads="自动加载角色", RespawnTime="重生时间",
    -- Lighting, atmosphere and post-processing.
    Ambient="环境光", Brightness="亮度", ColorShift_Bottom="底部色偏",
    ColorShift_Top="顶部色偏", EnvironmentDiffuseScale="环境漫反射强度",
    EnvironmentSpecularScale="环境镜面反射强度", GlobalShadows="全局阴影",
    LightingStyle="光照风格", OutdoorAmbient="室外环境光", Outlines="轮廓线",
    PrioritizeLightingQuality="优先光照质量", SelectionImageObject="选中图像对象",
    ShadowColor="阴影颜色", ShadowSoftness="阴影柔和度", Technology="光照技术",
    ClockTime="时钟时间", GeographicLatitude="地理纬度", TimeOfDay="一天中的时间",
    ExposureCompensation="曝光补偿", FogColor="雾颜色", FogEnd="雾结束距离",
    FogStart="雾起始距离", Density="密度", Offset="偏移", Decay="衰减颜色",
    Glare="眩光", Haze="雾霾", Intensity="强度", Threshold="阈值",
    Contrast="对比度", Saturation="饱和度", TintColor="色调颜色",
    FocusDistance="焦点距离", InFocusRadius="清晰区域半径",
    FarIntensity="远景模糊强度", NearIntensity="近景模糊强度", Spread="扩散",
    CelestialBodiesShown="显示天体", MoonAngularSize="月亮角尺寸",
    MoonTextureId="月亮纹理 ID", SkyboxBk="天空盒后面", SkyboxDn="天空盒底面",
    SkyboxFt="天空盒前面", SkyboxLf="天空盒左面", SkyboxRt="天空盒右面",
    SkyboxUp="天空盒顶面", SkyboxOrientation="天空盒朝向", StarCount="星星数量",
    SunAngularSize="太阳角尺寸", SunTextureId="太阳纹理 ID",
    -- Parts, models, physics and terrain.
    Position="位置", Size="尺寸", Orientation="朝向", Rotation="旋转",
    CFrame="坐标变换", PivotOffset="轴心偏移", WorldPivot="世界轴心",
    PrimaryPart="主零件", Scale="比例", Origin="原点", Direction="方向",
    RightVector="右方向向量", UpVector="上方向向量", LookVector="视线方向向量",
    Color="颜色", BrickColor="砖块颜色", Material="材质", Transparency="透明度",
    LocalTransparencyModifier="本地透明度修正", Reflectance="反射率",
    CastShadow="投射阴影", Anchored="固定", CanCollide="可碰撞",
    CanTouch="可触碰", CanQuery="可查询", CollisionGroup="碰撞组",
    CollisionGroupId="碰撞组 ID", Locked="锁定", Massless="无质量",
    Mass="质量", RootPriority="根零件优先级", CustomPhysicalProperties="自定义物理属性",
    CurrentPhysicalProperties="当前物理属性", Elasticity="弹性",
    ElasticityWeight="弹性权重", Friction="摩擦力", FrictionWeight="摩擦力权重",
    Velocity="速度", RotVelocity="旋转速度", AssemblyLinearVelocity="组合体线速度",
    AssemblyAngularVelocity="组合体角速度", AssemblyCenterOfMass="组合体质心",
    AssemblyMass="组合体质量", AssemblyRootPart="组合体根零件",
    Shape="形状", MeshId="网格 ID", TextureID="纹理 ID", TextureId="纹理 ID",
    MeshType="网格类型", VertexColor="顶点颜色", DoubleSided="双面渲染",
    RenderFidelity="渲染精度", CollisionFidelity="碰撞精度", LevelOfDetail="细节级别",
    ModelStreamingMode="模型流式加载模式", StreamingEnabled="启用流式加载",
    StreamingMinRadius="流式加载最小半径", StreamingTargetRadius="流式加载目标半径",
    StreamingIntegrityMode="流式加载完整性模式", ModelStreamingBehavior="模型流式加载行为",
    Gravity="重力", FallenPartsDestroyHeight="掉落零件销毁高度",
    CurrentCamera="当前摄像机", DistributedGameTime="游戏运行时间",
    Terrain="地形", WaterColor="水颜色", WaterReflectance="水反射率",
    WaterTransparency="水透明度", WaterWaveSize="水波尺寸", WaterWaveSpeed="水波速度",
    BottomSurface="底面类型", TopSurface="顶面类型", FrontSurface="前面类型",
    BackSurface="后面类型", LeftSurface="左面类型", RightSurface="右面类型",
    Front="前面", Back="后面", Left="左侧", Right="右侧", Top="顶部", Bottom="底部",
    -- Character and camera.
    Health="生命值", MaxHealth="最大生命值", WalkSpeed="行走速度",
    JumpPower="跳跃力度", JumpHeight="跳跃高度", UseJumpPower="使用跳跃力度",
    HipHeight="臀部高度", AutoRotate="自动转向", PlatformStand="站立平台模式",
    Sit="坐下", Jump="跳跃", MoveDirection="移动方向", FloorMaterial="地面材质",
    RigType="骨架类型", RootPart="根零件", SeatPart="座椅零件", TargetPoint="目标点",
    WalkToPoint="行走目标位置", WalkToPart="行走目标零件", BreakJointsOnDeath="死亡时断开关节",
    RequiresNeck="需要颈部", HealthDisplayType="生命值显示类型",
    HealthDisplayDistance="生命值显示距离", NameDisplayDistance="名称显示距离",
    DisplayDistanceType="显示距离类型", CameraOffset="摄像机偏移",
    CameraSubject="摄像机跟随对象", CameraType="摄像机类型", FieldOfView="视野角度",
    FieldOfViewMode="视野模式", DiagonalFieldOfView="对角视野角度",
    MaxAxisFieldOfView="最大轴视野角度", Focus="焦点", ViewportSize="视口尺寸",
    HeadLocked="头部锁定", HeadScale="头部缩放",
    -- GUI and text.
    Active="可交互", Enabled="启用", Visible="可见", ZIndex="显示层级",
    LayoutOrder="布局顺序", AnchorPoint="锚点", AbsolutePosition="绝对位置",
    AbsoluteSize="绝对尺寸", AbsoluteRotation="绝对旋转", AutomaticSize="自动尺寸",
    BackgroundColor3="背景颜色", BackgroundTransparency="背景透明度",
    BorderColor3="边框颜色", BorderSizePixel="边框像素宽度", BorderMode="边框模式",
    ClipsDescendants="裁剪子对象", Selectable="可选中", SelectionOrder="选择顺序",
    SelectionGroup="选择组", SelectionBehaviorDown="向下选择行为",
    SelectionBehaviorUp="向上选择行为", SelectionBehaviorLeft="向左选择行为",
    SelectionBehaviorRight="向右选择行为", NextSelectionDown="向下选中对象",
    NextSelectionUp="向上选中对象", NextSelectionLeft="向左选中对象",
    NextSelectionRight="向右选中对象", Interactable="允许交互",
    AutoButtonColor="自动按钮颜色", Modal="模态", Selected="已选中", Style="样式",
    Text="文本", ContentText="纯文本内容", TextColor3="文本颜色",
    TextTransparency="文本透明度", TextSize="文本字号", TextScaled="自动缩放文本",
    TextWrapped="文本自动换行", TextTruncate="文本截断", RichText="富文本",
    TextXAlignment="文本水平对齐", TextYAlignment="文本垂直对齐",
    TextStrokeColor3="文本描边颜色", TextStrokeTransparency="文本描边透明度",
    TextBounds="文本边界尺寸", TextFits="文本是否完整显示", LineHeight="行高",
    Font="字体", FontFace="字体资源", MaxVisibleGraphemes="最大可见字符数",
    PlaceholderText="占位文本", PlaceholderColor3="占位文本颜色",
    ClearTextOnFocus="聚焦时清空文本", MultiLine="多行文本", TextEditable="文本可编辑",
    CursorPosition="光标位置", SelectionStart="选择起点", ShowNativeInput="显示原生输入框",
    Image="图像", ImageColor3="图像颜色", ImageTransparency="图像透明度",
    ImageRectOffset="图像裁剪偏移", ImageRectSize="图像裁剪尺寸",
    ImageButton="图像按钮", HoverImage="悬停图像", PressedImage="按下图像",
    ScaleType="缩放方式", SliceCenter="九宫格中心", SliceScale="九宫格缩放",
    TileSize="平铺尺寸", ResampleMode="重采样模式", IsLoaded="已加载",
    CanvasSize="画布尺寸", CanvasPosition="画布位置", AutomaticCanvasSize="自动画布尺寸",
    AbsoluteCanvasSize="绝对画布尺寸", AbsoluteWindowSize="绝对窗口尺寸",
    ScrollBarThickness="滚动条宽度", ScrollBarImageColor3="滚动条颜色",
    ScrollBarImageTransparency="滚动条透明度", ScrollingDirection="滚动方向",
    ScrollingEnabled="启用滚动", ElasticBehavior="弹性滚动行为",
    VerticalScrollBarInset="垂直滚动条内边距", HorizontalScrollBarInset="水平滚动条内边距",
    VerticalScrollBarPosition="垂直滚动条位置", TopImage="滚动条顶部图像",
    MidImage="滚动条中部图像", BottomImage="滚动条底部图像",
    IgnoreGuiInset="忽略界面边距", ResetOnSpawn="重生时重置", DisplayOrder="显示顺序",
    ZIndexBehavior="层级行为", ScreenInsets="屏幕边距", SafeAreaCompatibility="安全区域兼容模式",
    ClipToDeviceSafeArea="裁剪到设备安全区域", Adornee="附着对象",
    AlwaysOnTop="始终置顶", LightInfluence="光照影响", MaxDistance="最大距离",
    StudsOffset="空间偏移", StudsOffsetWorldSpace="世界空间偏移",
    ExtentsOffset="边界偏移", SizeOffset="尺寸偏移", Face="表面",
    PixelsPerStud="每单位像素数", SizingMode="尺寸模式",
    Padding="间距", PaddingTop="顶部内边距", PaddingBottom="底部内边距",
    PaddingLeft="左侧内边距", PaddingRight="右侧内边距", FillDirection="排列方向",
    HorizontalAlignment="水平对齐", VerticalAlignment="垂直对齐", SortOrder="排序方式",
    CellSize="单元格尺寸", CellPadding="单元格间距", FillDirectionMaxCells="每行最大单元格数",
    StartCorner="起始角", AspectRatio="宽高比", AspectType="宽高比类型",
    DominantAxis="主轴", MinSize="最小尺寸", MaxSize="最大尺寸",
    MinTextSize="最小字号", MaxTextSize="最大字号", CornerRadius="圆角半径",
    ApplyStrokeMode="描边应用模式", Thickness="粗细", LineJoinMode="线条连接模式",
    -- Sounds, effects, attachments and constraints.
    SoundId="音频 ID", Volume="音量", PlaybackSpeed="播放速度", Playing="正在播放",
    Looped="循环播放", TimePosition="播放位置", TimeLength="时长", PlaybackLoudness="播放响度",
    PlayOnRemove="移除时播放", RollOffMode="音量衰减模式",
    RollOffMinDistance="音量衰减最小距离", RollOffMaxDistance="音量衰减最大距离",
    SoundGroup="音频组", Preview="预览", EmitterSize="发声范围",
    Texture="纹理", Lifetime="生命周期", Rate="发射速率", Speed="速度",
    Acceleration="加速度", Drag="阻力", EmissionDirection="发射方向",
    LightEmission="发光强度", LightEmissionMode="发光模式", LightInfluenceMode="光照影响模式",
    SpreadAngle="扩散角度", RotSpeed="旋转速度", LockedToPart="固定于零件",
    VelocityInheritance="速度继承", TimeScale="时间比例", ZOffset="深度偏移",
    ShapeStyle="形状样式", ShapeInOut="形状发射方式", Squash="挤压比例",
    WidthScale="宽度比例", Attachment0="附件 0", Attachment1="附件 1",
    Axis="轴", SecondaryAxis="次轴", WorldPosition="世界位置", WorldCFrame="世界坐标变换",
    WorldOrientation="世界朝向", WorldAxis="世界轴", WorldSecondaryAxis="世界次轴",
    Part0="零件 0", Part1="零件 1", C0="连接变换 0", C1="连接变换 1",
    Transform="变换", Force="作用力", Torque="扭矩", MaxForce="最大作用力",
    MaxTorque="最大扭矩", Responsiveness="响应度", ApplyAtCenterOfMass="作用于质心",
    AttachmentPoint="附着点", LimitsEnabled="启用限制", UpperAngle="角度上限",
    LowerAngle="角度下限", Restitution="恢复系数", Range="范围", Angle="角度",
    Shadows="投射阴影", Length="长度", MinLength="最小长度", MaxLength="最大长度",
    Stiffness="刚度", Damping="阻尼", FreeLength="自然长度", Radius="半径",
    FillColor="填充颜色", FillTransparency="填充透明度", OutlineColor="轮廓颜色",
    OutlineTransparency="轮廓透明度", DepthMode="深度模式",
    StudsPerTileU="水平平铺单位数", StudsPerTileV="垂直平铺单位数",
    OffsetStudsU="水平纹理偏移", OffsetStudsV="垂直纹理偏移",
    ToolTip="工具提示", RequiresHandle="需要握柄", CanBeDropped="允许丢弃",
    ManualActivationOnly="仅手动激活", Grip="握持变换", GripPos="握持位置",
    GripForward="握持前方向", GripRight="握持右方向", GripUp="握持上方向",
    Disabled="禁用", RunContext="运行上下文", Source="源代码", LinkedSource="关联源代码",
    Value="值", AnimationId="动画 ID", Loop="循环", Min="最小值", Max="最大值",
}
local categoryZh = {
    Appearance="外观", Data="数据", Permissions="权限", Behavior="行为",
    ["Material Pack"]="材质包", Attributes="自定义属性", Transform="变换",
    Part="零件", Physics="物理", Assembly="组合体", Collision="碰撞",
    Surface="表面", ["Surface Inputs"]="表面输入", Motion="运动",
    ["Object"]="对象", ["Pivot"]="轴心", ["Pivot Settings"]="轴心设置",
    ["Streaming"]="流式加载", ["Streaming Settings"]="流式加载设置",
    ["World"]="世界", ["Camera"]="摄像机", ["Terrain"]="地形", ["Water"]="水",
    ["Lighting"]="光照", ["Exposure"]="曝光", ["Fog"]="雾",
    ["Sky"]="天空", ["Image"]="图像", ["Text"]="文本", ["TextBox"]="文本框",
    ["Scrolling"]="滚动", ["ScrollingFrame"]="滚动框", ["Canvas"]="画布",
    ["Gui"]="界面", ["GUI"]="界面", ["Control"]="控件", ["Selection"]="选择",
    ["Layout"]="布局", ["Sizing"]="尺寸", ["Padding"]="内边距", ["Border"]="边框",
    ["Clipping"]="裁剪", ["Safe Area"]="安全区域", Localization="本地化",
    ["Character"]="角色", ["Controls"]="控制", ["Jump Settings"]="跳跃设置",
    ["Movement"]="移动", ["Game"]="游戏", ["Teams"]="队伍",
    ["State"]="状态", ["Camera Settings"]="摄像机设置", ["Display"]="显示",
    ["Attachments"]="附件", ["Axes"]="轴", ["Goals"]="目标", ["Limits"]="限制",
    ["Responsiveness"]="响应度", ["Force"]="作用力", ["Torque"]="扭矩",
    ["Slider"]="滑动", ["Cylinder"]="圆柱", ["Hinge"]="铰链", ["Spring"]="弹簧",
    ["AlignOrientation"]="朝向对齐", ["AlignPosition"]="位置对齐", ["Tuning"]="调节",
    ["Shape"]="形状", ["Emission"]="发射", ["Particles"]="粒子", ["Emitter"]="发射器",
    ["Flipbook"]="序列帧", ["Playback"]="播放", ["Sound"]="音频", ["Routing"]="音频路由",
    ["RollOff"]="音量衰减", ["Animation"]="动画", ["Performance"]="性能",
    ["Debug"]="调试", ["Unscriptable"]="不可脚本访问", ["Other"]="其他",
}
local function main()
    local UI={}
    local roots, ignored={},setmetatable({}, {__mode="k"})
    local language="English"
    function UI.Normalize(value)
        return (value=="中文" or value=="Chinese" or value=="zh-CN" or value=="zh") and "中文" or "English"
    end
    function UI.Translate(source)
        if language~="中文" then return source end
        if zh[source] then return zh[source] end
        for _, pair in ipairs({{"Deobf: ","反编译： "},{"Initializing Plugin: ","初始化插件： "},
            {"Files and folders: ","文件和文件夹： "},{"Game resources: ","游戏资源： "},{"Opened: ","已打开： "},{"Created: ","已创建： "}}) do
            if source:sub(1,#pair[1])==pair[1] then return pair[2]..source:sub(#pair[1]+1) end
        end
        return source
    end
    function UI.TranslateProperty(source, isCategory)
        if language~="中文" or Settings.TranslateProperties==false then return source end
        local dictionary=isCategory and categoryZh or propertyZh
        return dictionary[source] or source
    end
    function UI.RefreshProperties()
        local properties=Apps.Properties
        if properties and properties.Window then
            properties.Update()
            properties.Refresh()
        end
    end
    function UI.SetTranslateProperties(value)
        Settings.TranslateProperties=value~=false
        UI.RefreshProperties()
        return Settings.TranslateProperties
    end
    function UI.Ignore(object) ignored[object]=true end
    local function skip(object)
        if object.Name=="PropName" or object.Name=="ValueBox" or object.Name=="LineNumbers" or object.Name=="OutputTemplate" then return true end
        local current=object
        while current do
            if ignored[current] or current.Name=="Lines" or current.Name=="Output" or current.Name=="BackgroundOutput" then return true end
            if object.Name=="EntryName" and Apps.Explorer and Apps.Explorer.Window and current==Apps.Explorer.Window.Gui then return true end
            current=current.Parent
        end
        return false
    end
    local function render(entry)
        if skip(entry.Object) then return end
        local text=UI.Translate(entry.Source)
        entry.Rendered=text
        if entry.Object[entry.Property]~=text then entry.Object[entry.Property]=text end
    end
    function UI.Track(root)
        if roots[root] then return end
        local state={Connections={},Entries={}}
        roots[root]=state
        local bound=setmetatable({}, {__mode="k"})
        local function bind(object)
            if bound[object] or skip(object) then return end
            local property
            if object:IsA("TextBox") then property="PlaceholderText"
            elseif object:IsA("TextLabel") or object:IsA("TextButton") then property="Text" end
            if not property then return end
            bound[object]=true
            local entry={Object=object,Property=property,Source=object[property]}
            state.Entries[#state.Entries+1]=entry
            state.Connections[#state.Connections+1]=object:GetPropertyChangedSignal(property):Connect(function()
                if skip(object) then return end
                local value=object[property]
                if value==entry.Rendered then return end
                entry.Source=value
                render(entry)
            end)
            render(entry)
        end
        bind(root)
        for _, object in ipairs(root:GetDescendants()) do bind(object) end
        state.Connections[#state.Connections+1]=root.DescendantAdded:Connect(bind)
        state.Connections[#state.Connections+1]=root.Destroying:Connect(function()
            for _, c in ipairs(state.Connections) do c:Disconnect() end
            roots[root]=nil
        end)
    end
    function UI.SetLanguage(value)
        language=UI.Normalize(value)
        Settings.Language=language
        for _, state in pairs(roots) do
            for _, entry in ipairs(state.Entries) do pcall(render,entry) end
        end
        if Apps.Spy then Apps.Spy.RefreshLanguage() end
        UI.RefreshProperties()
        return language
    end
    function UI.Init()
        Settings.TranslateProperties=Settings.TranslateProperties~=false
        UI.SetLanguage(Settings.Language)
    end
    function UI.Destroy()
        for _, state in pairs(roots) do for _, c in ipairs(state.Connections) do c:Disconnect() end end
        roots={}
    end
    return UI
end
local module={InitDeps=initDeps,InitAfterMain=function() end,Main=main}
if gethsfuncs then _G.moduleData=module else return module end
