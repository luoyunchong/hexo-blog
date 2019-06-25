---
title: ABP使用文档
date: 2019-03-12 14:40:26
tags: ABP
description: 旧项目使用ABP框架时，.NET Framework下通用文档，最基础的类，服务，接口等。
category:
- ABP
---
## 具体入门与开发原理可参考此地址
https://blog.csdn.net/wulex/article/category/7256369/3

## abp入门系列
https://www.jianshu.com/p/a6e9ace79345

我们以通知公告为示例
1. 首先我们有一个公告信息的表结构，如下，像是否删除、新增时间等七个字段只需要继承FullAuditedEntity类即可

![image.png](https://upload-images.jianshu.io/upload_images/2001974-f36d31bc61fb36a0.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

项目目录位置，在Domain/Plat建立NoticeItems目录，以类+s设置文件夹。

![image.png](https://upload-images.jianshu.io/upload_images/2001974-0c0a238c497178ad.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

TelSCode.Domain.Plat.NoticeItems 此命名空间下的类如下，

```
 public class NoticeItem : FullAuditedEntity
    {
        /// <summary>
        /// 公告类别ID
        /// </summary>
        [StringLength(50)]
        public string BaseItemId { get; set; }
        /// <summary>
        /// 标题
        /// </summary>
        [StringLength(100)]
        public string Title { get; set; }
        /// <summary>
        /// 内容 
        /// </summary>
        public string Content { get; set; }
        /// <summary>
        ///  打开次数
        /// </summary>
        public int Times { get; set; }
        /// <summary>
        /// 新增人姓名
        /// </summary>

        [StringLength(50)]
        public string CreationUserName { get; set; }
        /// <summary>
        /// 部门
        /// </summary>
        [StringLength(50)]
        public string DepName { get; set; }
        /// <summary>
        /// 是否置顶
        /// </summary>

        public bool IsTop { get; set; }

        /// <summary>
        /// 置顶时间
        /// </summary>
        public DateTime? TopTime { get; set; }
        /// <summary>
        /// 发布时间
        /// </summary>
        public DateTime? DeployTime { get; set; }
        public bool IsImg { get; set; }
        /// <summary>
        /// 状态
        /// </summary>
        public string Status { get; set; }
        /// <summary>
        /// 图片地址
        /// </summary>
        public string ImgUrl { get; set; }
        /// <summary>
        /// 附件地址
        /// </summary>
        public string FileUrl { get; set; }

        /// <summary>
        /// 阅读量+1
        /// </summary>
        public void NewlyTimes()
        {
            this.Times++;
        }

    }
```

在此文件夹下把相关权限配置好

![image.png](https://upload-images.jianshu.io/upload_images/2001974-00a6d4607e89e9fc.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

具体配置如下

![image.png](https://upload-images.jianshu.io/upload_images/2001974-310610af5219023f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


数据以树的形式存放，公告信息这个菜单放到基础资料管理下，TypeCode为permission时，在菜单下不展示，是菜单下的权限配置，EnCode不能出现重复值,修改菜单时应在此位置修改对应的文字与排序方式、地址。如果是图标，将不自动更新。

```
new SysMenu {  DisplayName = "公告信息管理", Icon = "icon-standard-date-add", EnCode = "Plat.NoticeItem", LinkUrl = "/Plat/NoticeItem/Index", TypeCode = menu, SortCode = 20 ,
Childrens = new List<SysMenu>()
{
new SysMenu { DisplayName = "新增公告", EnCode = "Plat.NoticeItem.Add", TypeCode = permission, SortCode = 1 },
    new SysMenu { DisplayName = "编辑公告", EnCode = "Plat.NoticeItem.Edit", TypeCode = permission, SortCode = 2},
    new SysMenu { DisplayName = "删除公告", EnCode = "Plat.NoticeItem.Delete", TypeCode = permission, SortCode = 3 },
    new SysMenu { DisplayName = "公告列表", EnCode = "Plat.NoticeItem.GetGrid", TypeCode = permission, SortCode = 4 }
}
}
```
然后在EntityFramework的TelSCodeDbContext中增加一行 
```
        public virtual IDbSet<NoticeItem> NoticeItem { get; set; }
```
![image.png](https://upload-images.jianshu.io/upload_images/2001974-67a14080bf65ca46.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

在Application的Plat区域增加NoticeItems文件夹，我们以类名后缀加s建立文件夹，

![image.png](https://upload-images.jianshu.io/upload_images/2001974-d8352c0d3dcaff33.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

NoticeItemInput.cs文件夹，一般情况下只需要将NoticeItem中的字段复制过来即可
```
   [AutoMap(typeof(NoticeItem))]
    public class NoticeItemInput : EntityDto
    {
        public string BaseItemId { get; set; }
        [StringLength(100,ErrorMessage = "标题仅限100个字符")]
        public string Title { get; set; }
        public string Content { get; set; }
        public int Times { get; set; }
        public string CreationUserName { get; set; }
        public string DepName { get; set; }
        public bool IsTop { get; set; }
        public bool IsImg { get; set; }
        public string Status { get; set; }
        public string ImgUrl { get; set; }
        public string FileUrl { get; set; }
        public DateTime? TopTime { get; set; }
        public DateTime? DeployTime { get; set; }
    }
```
NoticeItemListDto 为列表上展示的数据字段
```
    [AutoMapFrom(typeof(NoticeItem))]
    public class NoticeItemListDto : EntityDto, IHasCreationTime
    {
        public string BaseItemId { get; set; }
        public string Title { get; set; }
        public string Content { get; set; }
        public int Times { get; set; }
        /// <summary>
        /// 回复次数
        /// </summary>
        public int CommentTimes { get; set; }
        public string CreationUserName { get; set; }
        public DateTime CreationTime { get; set; }

        public DateTime? DeployTime { get; set; }

        public bool IsTop { get; set; }
        public string StatusCode { get; set; }
    }
```
NoticeItemSearchDto为查询条件，继承PageDto即可，需要增加查询条件，则在此类中增加对应的属性。
```
    public class NoticeItemSearchDto : PageDto
    {
        public string BaseItemEnCode { get; set; }
        public string Title { get; set; }
    }
```
INoticeItemAppService .cs文件 夹
~~~
    public interface INoticeItemAppService : IUsualCrudAppService<NoticeItemInput, NoticeItemSearchDto, NoticeItemInput, int>
    {

    }
~~~
NoticeItemAppService.cs文件，一般情况下，此类继承UsualCrudAppService，继承接口INoticeItemAppService，即可拥有增、删、改、查的功能，如果想自定义查询实现，需要重写父类的CreateFilteredQuery方法，由于公告信息中业务要求，有置顶和置顶时间字段，需要根据最后置顶的时间倒序取数据，所以GetGridByCondition方法需要override下，即可解决，权限配置包括二部分，一种是给父类继承的UsualCurdAppService传相应的权限编码，分别：
```
base.DeletePermissionName="Plat.NoticeItem.Delete";
 base.CreatePermissionName = "Plat.NoticeItem.Add";
base.UpdatePermissionName = "Plat.NoticeItem.Edit";
```
在方法名上使用此权限属性配置该方法对应的权限信息。
```
     [AbpAuthorize("Plat.NoticeItem.GetGrid")]
```
调用 base.CreateOrUpdate方法时，即会判断用户是否有Plat.NoticeItem.Add权限
```
  public class NoticeItemAppService : UsualCrudAppService<NoticeItem, NoticeItemInput, NoticeItemSearchDto, NoticeItemInput, int>, INoticeItemAppService
    {

        #region 构造函数
        private readonly IRepository<NoticeItem> _noticeItemRepository;
        private RoleManager RoleManager;
        private readonly ISqlExecuter _iSqlExecuter;
        public NoticeItemAppService(IRepository<NoticeItem> noticeItemRepository, ISqlExecuter iSqlExecuter, RoleManager roleManager) : base(noticeItemRepository)
        {
            this._noticeItemRepository = noticeItemRepository;
            _iSqlExecuter = iSqlExecuter;
            RoleManager = roleManager;
            base.DeletePermissionName = "Plat.NoticeItem.Delete";
            base.CreatePermissionName = "Plat.NoticeItem.Add";
            base.UpdatePermissionName = "Plat.NoticeItem.Edit";
        }
        #endregion

        public override async Task CreateOrUpdate(NoticeItemInput input)
        {
            if (input.IsTop)
            {
                input.TopTime = DateTime.Now;
            }
            else
            {
                input.TopTime = null;
            }

            if (input.Status == StatusCode.Submit.ToString())
            {
                input.DeployTime = DateTime.Now;
            }
            await base.CreateOrUpdate(input);
        }

        protected override IQueryable<NoticeItem> CreateFilteredQuery(NoticeItemSearchDto input)
        {
            return base.CreateFilteredQuery(input)
                .WhereIf(!string.IsNullOrWhiteSpace(input.Title), m => m.Title.Contains(input.Title));
        }

        [AbpAuthorize("Plat.NoticeItem.GetGrid")]
        public override EasyUiListResultDto<NoticeItemInput> GetGridByCondition(NoticeItemSearchDto input)
        {
            var rows = this.CreateFilteredQuery(input).OrderBy(r => r.IsTop).PageEasyUiBy(input).OrderByDescending(r => r.TopTime).MapTo<List<NoticeItemInput>>();

            return new EasyUiListResultDto<NoticeItemInput>(input.Total, rows);
        }
```
NoticeItemController.cs 此类注入IAbpFileManager 去解析保存的文件，供前台编辑页面时使用。
```

    public class NoticeItemController : TelSCodeControllerBase
    {
        #region 构造函数
        private readonly INoticeItemAppService _noticeitemAppService;
        private readonly IAbpFileManager _abpFileManager;
        public NoticeItemController(INoticeItemAppService noticeitemAppService, IAbpFileManager abpFileManager)
        {
            this._abpFileManager = abpFileManager;
            this._noticeitemAppService = noticeitemAppService;
        }
        #endregion

        #region 视图
        public ActionResult Index()
        {
            return View();
        }

        [AbpMvcAuthorize("Plat.NoticeItem.Add", "Plat.NoticeItem.Edit")]
        public ActionResult CreateOrUpdateModal()
        {
            return View();
        }
   
        #region 数据
        public async Task<JsonResult> GetInfoForEdit(int id)
        {
            var output = await _noticeitemAppService.GetInfoForEdit(id);

            if (id == 0)
            {
                output.CreationUserName = AbpSession.GetLoginName();
            }

            NoticeItemViewModel noticeItemViewModel = new NoticeItemViewModel(
                  _abpFileManager.GetFileOutput(output.FileUrl),
                  _abpFileManager.GetFileOutput(output.ImgUrl),
                  output
                );

            return Json(noticeItemViewModel);
        }

        [AbpMvcAuthorize("Plat.NoticeItem.GetGrid")]
        public JsonResult GetGridByCondition(NoticeItemSearchDto input)
        {
            var gridData = _noticeitemAppService.GetGridByCondition(input);
            return Json(gridData);
        }

        #endregion
    }
```
公告信息因为有文件上传，所以需要新建一个NoticeItemViewModel 类
在TelSCode.Web中Plat区域Models新建文件夹NoticeItems，新建类NoticeItemViewModel.cs

![image.png](https://upload-images.jianshu.io/upload_images/2001974-c99897c2255cd117.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

```
   [AutoMapFrom(typeof(NoticeItemInput))]
    public class NoticeItemViewModel : NoticeItemInput
    {
        public List<AbpFileOutput> AbpFileOutput { get; set; }
        public List<AbpFileOutput> AbpImgFileOutput { get; set; }
        public NoticeItemViewModel(List<AbpFileOutput> fileUrlOutputs, List<AbpFileOutput> imgFileUrlOutputs, NoticeItemInput noticeItemInput)
        {
            AbpFileOutput = fileUrlOutputs;
            AbpImgFileOutput = imgFileUrlOutputs;

            noticeItemInput.MapTo(this);
        }
    }

```

接下来是界面，新增编辑在一个界面中，一个页面对应一个js，使用@Html.InCludeScript引用，不会有缓存问题，发布之后会生成版本号。

![image.png](https://upload-images.jianshu.io/upload_images/2001974-4934ca2974d14475.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


Index.cshtml

```
@using Abp.Web.Mvc.Extensions
@{
    ViewBag.Title = "通知公告";
}

@section scripts{
    @Html.IncludeScript("~/bower_components/webuploader/webuploader.min.js")
    @Html.IncludeScript("~/bower_components/staticfile/libs/abp.webuploader.js")
    @Html.IncludeScript("~/bower_components/wangEditor/wangEditor.min.js")
    @Html.IncludeScript("~/bower_components/wangEditor/wangEditor-plugin.js")


    <script>
        var gridUI = gridUI ||
            {
                BaseItemEnCode: $.util.request['name'] == undefined ? "" : $.util.request['name']
            };
    </script>

    @Html.IncludeScript("~/Areas/Plat/Views/NoticeItem/Index.js")

}

@section styles{
    <link href="~/bower_components/webuploader/webuploader.css" rel="stylesheet" />
    <link href="~/bower_components/wangEditor/wangEditor-plugin.css" rel="stylesheet" />
    @Html.IncludeStyle("~/Areas/Plat/Views/NoticeItem/Index.js")
}

<div class="easyui-layout" data-options="fit:true">
    <div data-options="region:'north',border:false" style="height: 54px; overflow: hidden;">
        <form id="searchForm">
            <table class="kv-table no-border">
                <tr>
                    <th class="kv-label" style="text-align:center">标题</th>
                    <td class="kv-content">
                        <input name="Title" id="Title" class="easyui-textbox" />
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="com.filter('#searchForm', '#dgGrid');">查询</a>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-undo'" onclick="com.clear('#searchForm', '#dgGrid')">清空</a>
                    </td>
                </tr>
            </table>
        </form>
    </div>
    <div data-options="region:'center',border:false">
        <table id="dgGrid"></table>
    </div>
</div>
```

同目录下建一个Index.js ，我们使用闭包的形式来组织代码结构，将可配置项放在了上面，不强制要求，这里只为方便修改。使用时，将NoticeItem替换相应的类名，noticeServcice替换成相应的xxxservcie。abp.services.app.noticeItem中的noticeItem中n是首字母变成小写，这是后台生成的service，要按照此规定使用。
```
var gridUI = gridUI || {};
(function () {
    var noticeService = abp.services.app.noticeItem;
    var gridUrl = '/Plat/NoticeItem/GetGridByCondition?BaseItemEnCode=' + gridUI.BaseItemEnCode;
    var editModalUrl = '/Plat/NoticeItem/CreateOrUpdateModal';
    var readModalUrl = '/Plat/NoticeItem/ReadModal';
    var dgGrid, dgGridId = "#dgGrid";

    $.extend(gridUI,
        {
            loadGrid: function () {
                var baseEnCode = 'Plat.NoticeItem.';

                var toolbar = [{ text: "刷新", iconCls: "icon-reload", handler: function () { com.btnRefresh(dgGridId); } },
                { text: "新增", EnCode: baseEnCode + 'Add', iconCls: "icon-add", handler: gridUI.btnAdd },
                { text: "编辑", EnCode: baseEnCode + 'Edit', iconCls: "icon-edit", handler: gridUI.btnEdit },
                { text: "删除", EnCode: baseEnCode + 'Delete', iconCls: "icon-remove", handler: gridUI.btnDelete }];
                toolbar = com.authorizeButton(toolbar);
                if (gridUI.BaseItemEnCode != "") {
                    toolbar = [];
                }

                dgGrid = $(dgGridId).datagrid({
                    url: gridUrl,
                    toolbar: toolbar,
                    columns: [[
                        {
                            field: 'Id', title: '查看', width: 20, align: 'center', formatter: function (value, row) {
                                return String.format('<button class="btn btn-default btn-xs" type="button" onclick="gridUI.showDetails(\'{0}\')"><i class="fa fa-search"></i></button>', value);
                            }
                        },
                        { field: 'Title', title: '标题', width: 80 },
                        {
                            field: 'BaseItemId', title: '类别', width: 80, formatter: function (value) {
                                if (top.clients.dataItems['NoticeItem']) {
                                    return top.clients.dataItems['NoticeItem'][value];
                                } else {
                                    return '';
                                }
                            }
                        },
                        { field: 'CreationUserName', title: '发布人姓名', width: 160 },
                        { field: 'IsTop', title: '是否置顶', width: 50, formatter: com.formatYes },
                        {
                            field: 'Status', title: '状态', width: 50, formatter: function (value) {
                                var objMsg = {
                                    "primary": {
                                        text: "发布",
                                        'case': ['Submit']
                                    },
                                    "info": {
                                        text: "暂存",
                                        'case': ['TempSave']
                                    }
                                };
                                return com.formatMsg(value, objMsg);
                            }
                        }
                    ]]
                });
            },
            editInfo: function (title, icon, id) {
                var pDialog = com.dialog({
                    title: title,
                    width: '100%',
                    height: '100%',
                    href: editModalUrl,
                    iconCls: icon,
                    buttons: [
                        {
                            text: '发布',
                            iconCls: 'icon-ok',
                            handler: function () {
                                gridUI.submit(pDialog, "Submit");
                            }
                        }, {
                            text: '暂存',
                            iconCls: 'icon-save',
                            handler: function () {
                                gridUI.submit(pDialog, "TempSave");
                            }

                        }
                    ],
                    onLoad: function () {
                        editUI.setForm(id);
                    }
                });
            },
            showDetails: function (id) {
                com.dialog({
                    title: "详情",
                    width: 1500,
                    height: 800,
                    href: readModalUrl,
                    queryParams: {
                        id: id
                    }
                });
            },
            btnAdd: function () {
                gridUI.editInfo('新增公告', 'icon-add');
            },
            btnEdit: function () {
                com.edit(dgGridId, function (id) {
                    gridUI.editInfo("编辑公告", 'icon-edit', id);
                });
            },
            btnDelete: function () {
                com.deleted(noticeService, dgGridId);
            },
            submit: function (pDialog, status) {
                var f = $("#editForm");
                var isValid = f.form('validate');
                if (!isValid) {
                    return;
                }

                var objForm = f.formSerialize();
                objForm.Content = editor.txt.html();
                objForm.Status = status;

                com.setBusy(pDialog, true);
                noticeService.createOrUpdate(objForm, { showMsg: true })
                    .done(function () {
                        com.btnRefresh();
                        pDialog.dialog('close');
                    })
                    .always(function () {
                        com.setBusy(pDialog, false);
                    });
            }
        });

    $(function () {
        gridUI.loadGrid();
    });

})();

```
CreateOrUpdate.cshtml

```
@using Abp.Web.Mvc.Extensions
@{
    Layout = null;
    ViewBag.Title = "通知公告管理";
}
@Html.IncludeScript("/Areas/Plat/Views/NoticeItem/CreateOrUpdateModal.js")
<div class="layui-layer-content">
    <form id="editForm">
        <table class="kv-table">
            <tr>
                <th class="kv-label"><span class="red">*</span>标题</th>
                <td class="kv-content" colspan="3">
                    <input id="Title" name="Title" type="text" class="easyui-textbox" data-options="required:true" style="width:569px" />
                    <input id="Id" name="Id" type="hidden" />
                    <input type="hidden" id="CreationUserName" name="CreationUserName" />
                    <input type="hidden" name="BaseItemCode" value="" />
                </td>
            </tr>
            <tr>
                <th class="kv-label">置顶</th>
                <td class="kv-content" style="width:215px">
                    <input name="IsTop" id="IsTop" class="easyui-switchbutton">
                </td>
                <th class="kv-label">公告类别</th>
                <td class="kv-content">
                    <input name="BaseItemId" id="BaseItemId" />
                </td>
            </tr>
            <tr>
                <th>附件</th>
                <td colspan="3">
                    <div id="fileUrl"></div>
                </td>
            </tr>
            @*<tr>
                    <th class="kv-label">是否图片新闻</th>
                    <td class="kv-content" colspan="3">
                        <input name="IsImg" id="IsImg" class="easyui-switchbutton">
                    </td>
                </tr>*@
            <tr id="IsImgNews">
                <th>上传图片</th>
                <td colspan="3">
                    <input name="IsImg" id="IsImg" type="hidden" value="true">
                    <div id="imgUrl" style="position: relative;"></div>
                </td>
            </tr>
            <tr>
                <th class="kv-label">内容</th>
                <td class="kv-content" colspan="3">
                    <div id="Content" style="position: relative;"></div>
                </td>
            </tr>
        </table>
    </form>
</div>
```
CreateOrUpdate.js
```
var Img;
var editor;
var editUI = {
    setForm: function (id) {

        var E = window.wangEditor;
        editor = new E('#Content');
        editor.customConfig = com.editor.customConfig;
        editor.create();
        E.plugins.init({
            elem: '#Content',
            plugins: ['fullscreen']
        });


        //实例化文件上传
        $("#imgUrl").powerWebUpload({
            uploadType: 'img'
        });
        $("#fileUrl").powerWebUpload();

        $('#BaseItemId').combobox({
            url: com.baseUrl + '/baseItem/GetComBoJson?enCode=NoticeItem',
            required: true,
            validType: "comboxValidate['请选择公告类别']"
        });

        //function changeIsImg(checked) {
        //    if (checked) {
        //        $('#IsImgNews').css('display', '');
        //    } else {
        //        $('#IsImgNews').css('display', 'none');
        //    }
        //}

        //$('#IsImg').switchbutton({
        //    onChange: function (checked) {
        //        changeIsImg(checked);
        //    }
        //});

        com.setForm(id, function (data) {
            var f = $("#editForm");
            if (id) {
                setTimeout(function () {
                    editor.txt.html(data.Content);
                }, 666);
            }



            webuploader.loadFile({
                elem: '#imgUrl',
                rows: data.AbpImgFileOutput
            });

            webuploader.loadFile({
                elem: '#fileUrl',
                rows: data.AbpFileOutput
            });
            com.loadSwithButton($('.layui-layer-content'), data);
            //changeIsImg(data.IsImg);
        });
    }
}
```

