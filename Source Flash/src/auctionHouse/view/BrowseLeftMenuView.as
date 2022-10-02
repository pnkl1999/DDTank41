package auctionHouse.view
{
   import auctionHouse.event.AuctionHouseEvent;
   import auctionHouse.model.AuctionHouseModel;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.SimpleDropListTarget;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.CateCoryInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   import flash.utils.Dictionary;
   
   public class BrowseLeftMenuView extends Sprite implements Disposeable
   {
      
      private static const ALL:int = -1;
      
      private static const WEAPON:int = 25;
      
      private static const SUB_WEAPON:int = 7;
      
      private static const OFFHAND:int = 17;
      
      private static const CLOTH:int = 21;
      
      private static const HAT:int = 1;
      
      private static const GLASS:int = 2;
      
      private static const SUB_CLOTH:int = 5;
      
      private static const JEWELRY:int = 24;
      
      private static const BEAUTY:int = 22;
      
      private static const HAIR:int = 3;
      
      private static const ORNAMENT:int = 4;
      
      private static const EYES:int = 6;
      
      private static const SUITS:int = 13;
      
      private static const WINGS:int = 15;
      
      private static const STRENTH:int = 1100;
      
      private static const STRENTH_1:int = 1101;
      
      private static const STRENTH_2:int = 1102;
      
      private static const STRENTH_3:int = 1103;
      
      private static const STRENTH_4:int = 1104;
      
      private static const STRENTH_5:int = 1110;
      
      private static const COMPOSE:int = 1105;
      
      private static const ZHUQUE:int = 1106;
      
      private static const XUANWU:int = 1107;
      
      private static const QINGLONG:int = 1108;
      
      private static const BAIHU:int = 1109;
      
      private static const SPHERE:int = 26;
      
      private static const TRIANGLE:int = 27;
      
      private static const ROUND:int = 28;
      
      private static const SQUERE:int = 29;
      
      private static const WISHBEAD:int = 35;
      
      private static const Drill:int = 1115;
      
      private static const DrillLv1:int = 1116;
      
      private static const DrillLv2:int = 1117;
      
      private static const DrillLv3:int = 1118;
      
      private static const DrillLv4:int = 1119;
      
      private static const PATCH:int = 30;
      
      private static const WUQISP:int = 1111;
      
      private static const FUWUQISP:int = 1112;
      
      private static const CARDS:int = 31;
      
      private static const FREAKCARD:int = 1113;
      
      private static const EQUIPCARD:int = 1114;
      
      private static const PROP:int = 23;
      
      private static const UNFIGHT_PROP:int = 11;
      
      private static const PAOPAO:int = 16;
       
      
      private var menu:VerticalMenu;
      
      private var list:ScrollPanel;
      
      private var _name:SimpleDropListTarget;
      
      private var searchStatus:Boolean;
      
      private var _searchBtn:BaseButton;
      
      private var _searchValue:String;
      
      private var _glowState:Boolean;
      
      private var _dictionary:Dictionary;
      
      private var _dimListArr:Array;
      
      private var _isForAll:Boolean = true;
      
      public function BrowseLeftMenuView()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         var _loc1_:Scale9CornerImage = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.LeftBG1");
         addChild(_loc1_);
         var _loc2_:Scale9CornerImage = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.LeftBG2");
         addChild(_loc2_);
         var _loc3_:MutipleImage = ComponentFactory.Instance.creat("auctionHouse.LeftBG");
         addChild(_loc3_);
         this._searchBtn = ComponentFactory.Instance.creat("auctionHouse.baidu_btn");
         addChild(this._searchBtn);
         this._name = ComponentFactory.Instance.creat("auctionHouse.baiduText");
         this._searchValue = "";
         this._name.maxChars = 30;
         addChild(this._name);
         this.list = ComponentFactory.Instance.creat("auctionHouse.BrowseLeftScrollpanel");
         addChild(this.list);
         this.list.hScrollProxy = ScrollPanel.OFF;
         this.list.vScrollProxy = ScrollPanel.ON;
         this.menu = new VerticalMenu(11,36,33);
         this.list.setView(this.menu);
         this._dictionary = new Dictionary();
         this._dimListArr = new Array();
      }
      
      private function menuRefrash(param1:Event) : void
      {
         this.list.invalidateViewport();
      }
      
      private function addEvent() : void
      {
         StageReferance.stage.addEventListener(MouseEvent.CLICK,this._clickStage);
         this._name.addEventListener(MouseEvent.MOUSE_DOWN,this._clickName);
         this._name.addEventListener(Event.CHANGE,this._nameChange);
         this._name.addEventListener(KeyboardEvent.KEY_UP,this._nameKeyUp);
         this._name.addEventListener(Event.ADDED_TO_STAGE,this.setFocus);
         this._searchBtn.addEventListener(MouseEvent.CLICK,this.__searchCondition);
         this.menu.addEventListener(VerticalMenu.MENU_CLICKED,this.menuItemClick);
         this.menu.addEventListener(VerticalMenu.MENU_REFRESH,this.menuRefrash);
      }
      
      private function removeEvent() : void
      {
         StageReferance.stage.removeEventListener(MouseEvent.CLICK,this._clickStage);
         this._name.removeEventListener(MouseEvent.MOUSE_DOWN,this._clickName);
         this._name.removeEventListener(Event.CHANGE,this._nameChange);
         this._name.removeEventListener(KeyboardEvent.KEY_UP,this._nameKeyUp);
         this._name.removeEventListener(Event.ADDED_TO_STAGE,this.setFocus);
         this._searchBtn.removeEventListener(MouseEvent.CLICK,this.__searchCondition);
         this.menu.removeEventListener(VerticalMenu.MENU_CLICKED,this.menuItemClick);
         this.menu.removeEventListener(VerticalMenu.MENU_REFRESH,this.menuRefrash);
      }
      
      private function _clickName(param1:MouseEvent) : void
      {
         if(this._name.text == LanguageMgr.GetTranslation("tank.auctionHouse.view.pleaseInputOnThere"))
         {
            this._name.text = "";
         }
      }
      
      private function setFocus(param1:Event) : void
      {
         this._name.text = LanguageMgr.GetTranslation("tank.auctionHouse.view.pleaseInputOnThere");
         this._searchValue = "";
         this._name.setFocus();
         this._name.setCursor(this._name.text.length);
      }
      
      public function setFocusName() : void
      {
         this._name.setFocus();
      }
      
	  internal function getInfo() : CateCoryInfo
      {
         if(this._isForAll)
         {
            return this.getMainCateInfo(ALL,LanguageMgr.GetTranslation("tank.auctionHouse.view.BrowseLeftMenuView.All"));
         }
         if(this.menu.currentItem)
         {
            return this.menu.currentItem.info as CateCoryInfo;
         }
         return this.getMainCateInfo(ALL,LanguageMgr.GetTranslation("tank.auctionHouse.view.BrowseLeftMenuView.All"));
      }
      
	  internal function setSelectType(param1:CateCoryInfo) : void
      {
      }
      
	  internal function getType() : int
      {
         if(this._isForAll)
         {
            return -1;
         }
         if(this.menu.currentItem)
         {
            return this.menu.currentItem.info.ID;
         }
         return -1;
      }
      
	  internal function setCategory(param1:Vector.<CateCoryInfo>) : void
      {
         var _loc12_:CateCoryInfo = null;
         var _loc13_:CateCoryInfo = null;
         var _loc14_:BrowseLeftMenuItem = null;
         var _loc15_:CateCoryInfo = null;
         var _loc16_:BrowseLeftMenuItem = null;
         var _loc17_:CateCoryInfo = null;
         var _loc18_:BrowseLeftMenuItem = null;
         var _loc19_:BrowseLeftMenuItem = null;
         var _loc20_:BrowseLeftMenuItem = null;
         var _loc21_:BrowseLeftMenuItem = null;
         var _loc22_:BrowseLeftMenuItem = null;
         var _loc23_:BrowseLeftMenuItem = null;
         var _loc24_:BrowseLeftMenuItem = null;
         var _loc25_:BrowseLeftMenuItem = null;
         var _loc26_:BrowseLeftMenuItem = null;
         var _loc27_:BrowseLeftMenuItem = null;
         var _loc28_:BrowseLeftMenuItem = null;
         var _loc29_:BrowseLeftMenuItem = null;
         var _loc30_:BrowseLeftMenuItem = null;
         var _loc31_:BrowseLeftMenuItem = null;
         var _loc32_:BrowseLeftMenuItem = null;
         var _loc33_:BrowseLeftMenuItem = null;
         var _loc34_:BrowseLeftMenuItem = null;
         var _loc35_:BrowseLeftMenuItem = null;
         var _loc36_:CateCoryInfo = null;
         var _loc37_:BrowseLeftMenuItem = null;
         var _loc38_:CateCoryInfo = null;
         var _loc39_:BrowseLeftMenuItem = null;
         var _loc40_:CateCoryInfo = null;
         var _loc41_:BrowseLeftMenuItem = null;
         var _loc42_:CateCoryInfo = null;
         var _loc43_:BrowseLeftMenuItem = null;
         var _loc44_:BrowseLeftMenuItem = null;
         LanguageMgr.GetTranslation("tank.auctionHouse.view.BrowseLeftMenuView.Weapon");
         var _loc2_:BrowseLeftMenuItem = new BrowseLeftMenuItem(new BrowserLeftStripAsset(),this.getMainCateInfo(CLOTH,LanguageMgr.GetTranslation("tank.auctionHouse.view.cloth")));
         var _loc3_:BrowseLeftMenuItem = new BrowseLeftMenuItem(new BrowserLeftStripAsset(),this.getMainCateInfo(BEAUTY,LanguageMgr.GetTranslation("tank.auctionHouse.view.beauty")));
         var _loc4_:BrowseLeftMenuItem = new BrowseLeftMenuItem(new BrowserLeftStripAsset(),this.getMainCateInfo(PROP,LanguageMgr.GetTranslation("tank.auctionHouse.view.prop")));
         var _loc5_:BrowseLeftMenuItem = new BrowseLeftMenuItem(new BrowserLeftStripAsset(),this.getMainCateInfo(WEAPON,LanguageMgr.GetTranslation("tank.auctionHouse.view.BrowseLeftMenuView.Weapon")));
         var _loc6_:BrowseLeftMenuItem = new BrowseLeftMenuItem(new BrowserLeftStripAsset(),this.getMainCateInfo(STRENTH,LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.qianghuashi")));
         var _loc7_:BrowseLeftMenuItem = new BrowseLeftMenuItem(new BrowserLeftStripAsset(),this.getMainCateInfo(COMPOSE,LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.hechengshi")));
         var _loc8_:BrowseLeftMenuItem = new BrowseLeftMenuItem(new BrowserLeftStripAsset(),this.getMainCateInfo(SPHERE,LanguageMgr.GetTranslation("tank.auctionHouse.view.sphere")));
         var _loc9_:BrowseLeftMenuItem = new BrowseLeftMenuItem(new BrowserLeftStripAsset(),this.getMainCateInfo(Drill,LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.drill")));
         var _loc10_:BrowseLeftMenuItem = new BrowseLeftMenuItem(new BrowserLeftStripAsset(),this.getMainCateInfo(PATCH,LanguageMgr.GetTranslation("tank.auctionHouse.view.rarechip")));
         var _loc11_:BrowseLeftMenuItem = new BrowseLeftMenuItem(new BrowserLeftStripAsset(),this.getMainCateInfo(CARDS,LanguageMgr.GetTranslation("tank.auctionHouse.view.cards")));
         this.menu.addItemAt(_loc5_,-1);
         this.menu.addItemAt(_loc2_,-1);
         this.menu.addItemAt(_loc3_,-1);
         this.menu.addItemAt(_loc6_,-1);
         this.menu.addItemAt(_loc7_,-1);
         this.menu.addItemAt(_loc8_,-1);
         this.menu.addItemAt(_loc9_,-1);
         this.menu.addItemAt(_loc10_,-1);
         this.menu.addItemAt(_loc11_,-1);
         this.menu.addItemAt(_loc4_,-1);
         for each(_loc12_ in param1)
         {
            if(_loc12_.ID == HAT || _loc12_.ID == GLASS || _loc12_.ID == SUB_CLOTH)
            {
               _loc44_ = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),_loc12_);
               this.menu.addItemAt(_loc44_,1);
            }
            else if(_loc12_.ID == SUITS || _loc12_.ID == WINGS || _loc12_.ID == EYES || _loc12_.ID == ORNAMENT || _loc12_.ID == HAIR)
            {
               _loc44_ = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),_loc12_);
               this.menu.addItemAt(_loc44_,2);
            }
            else if(_loc12_.ID == UNFIGHT_PROP || _loc12_.ID == PAOPAO)
            {
               _loc44_ = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),_loc12_);
               this.menu.addItemAt(_loc44_,9);
            }
            else
            {
               _loc44_ = null;
            }
         }
         _loc13_ = new CateCoryInfo();
         _loc13_.ID = JEWELRY;
         _loc13_.Name = LanguageMgr.GetTranslation("tank.auctionHouse.view.jewelry");
         _loc14_ = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),_loc13_);
         this.menu.addItemAt(_loc14_,1);
         _loc15_ = new CateCoryInfo();
         _loc15_.ID = SUB_WEAPON;
         _loc15_.Name = LanguageMgr.GetTranslation("tank.auctionHouse.view.BrowseLeftMenuView.Weapon");
         _loc16_ = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),_loc15_);
         this.menu.addItemAt(_loc16_,0);
         _loc17_ = new CateCoryInfo();
         _loc17_.ID = OFFHAND;
         _loc17_.Name = LanguageMgr.GetTranslation("tank.auctionHouse.view.offhand");
         _loc18_ = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),_loc17_);
         this.menu.addItemAt(_loc18_,0);
         _loc19_ = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),this.getMainCateInfo(STRENTH_1,LanguageMgr.GetTranslation("tank.auctionHouse.view.BrowseLeftMenuView.qianghua1")));
         _loc20_ = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),this.getMainCateInfo(STRENTH_2,LanguageMgr.GetTranslation("tank.auctionHouse.view.BrowseLeftMenuView.qianghua2")));
         _loc21_ = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),this.getMainCateInfo(STRENTH_3,LanguageMgr.GetTranslation("tank.auctionHouse.view.BrowseLeftMenuView.qianghua3")));
         _loc22_ = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),this.getMainCateInfo(STRENTH_4,LanguageMgr.GetTranslation("tank.auctionHouse.view.BrowseLeftMenuView.qianghua4")));
         _loc23_ = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),this.getMainCateInfo(STRENTH_5,LanguageMgr.GetTranslation("tank.auctionHouse.view.BrowseLeftMenuView.qianghua5")));
         this.menu.addItemAt(_loc19_,3);
         this.menu.addItemAt(_loc20_,3);
         this.menu.addItemAt(_loc21_,3);
         this.menu.addItemAt(_loc22_,3);
         this.menu.addItemAt(_loc23_,3);
         _loc24_ = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),this.getMainCateInfo(ZHUQUE,LanguageMgr.GetTranslation("BrowseLeftMenuView.zhuque")));
         _loc25_ = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),this.getMainCateInfo(XUANWU,LanguageMgr.GetTranslation("BrowseLeftMenuView.xuanwu")));
         _loc26_ = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),this.getMainCateInfo(QINGLONG,LanguageMgr.GetTranslation("BrowseLeftMenuView.qinglong")));
         _loc27_ = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),this.getMainCateInfo(BAIHU,LanguageMgr.GetTranslation("BrowseLeftMenuView.baihu")));
         this.menu.addItemAt(_loc24_,4);
         this.menu.addItemAt(_loc25_,4);
         this.menu.addItemAt(_loc26_,4);
         this.menu.addItemAt(_loc27_,4);
         _loc28_ = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),this.getMainCateInfo(WUQISP,LanguageMgr.GetTranslation("BrowseLeftMenuView.wuqisp")));
         _loc29_ = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),this.getMainCateInfo(FUWUQISP,LanguageMgr.GetTranslation("BrowseLeftMenuView.fuwuqisp")));
         this.menu.addItemAt(_loc28_,7);
         this.menu.addItemAt(_loc29_,7);
         _loc30_ = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),this.getMainCateInfo(FREAKCARD,LanguageMgr.GetTranslation("BrowseLeftMenuView.freakCard")));
         _loc31_ = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),this.getMainCateInfo(EQUIPCARD,LanguageMgr.GetTranslation("BrowseLeftMenuView.equipCard")));
         this.menu.addItemAt(_loc30_,8);
         this.menu.addItemAt(_loc31_,8);
         _loc32_ = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),this.getMainCateInfo(DrillLv1,LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.drillnote",DrillLv1 - Drill)));
         _loc33_ = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),this.getMainCateInfo(DrillLv2,LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.drillnote",DrillLv2 - Drill)));
         _loc34_ = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),this.getMainCateInfo(DrillLv3,LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.drillnote",DrillLv3 - Drill)));
         _loc35_ = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),this.getMainCateInfo(DrillLv4,LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.drillnote",DrillLv4 - Drill)));
         this.menu.addItemAt(_loc32_,6);
         this.menu.addItemAt(_loc33_,6);
         this.menu.addItemAt(_loc34_,6);
         this.menu.addItemAt(_loc35_,6);
         _loc36_ = new CateCoryInfo();
         _loc36_.ID = TRIANGLE;
         _loc36_.Name = LanguageMgr.GetTranslation("tank.auctionHouse.view.triangle");
         _loc37_ = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),_loc36_);
         this.menu.addItemAt(_loc37_,5);
         _loc38_ = new CateCoryInfo();
         _loc38_.ID = ROUND;
         _loc38_.Name = LanguageMgr.GetTranslation("tank.auctionHouse.view.round");
         _loc39_ = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),_loc38_);
         this.menu.addItemAt(_loc39_,5);
         _loc40_ = new CateCoryInfo();
         _loc40_.ID = SQUERE;
         _loc40_.Name = LanguageMgr.GetTranslation("tank.auctionHouse.view.square");
         _loc41_ = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),_loc40_);
         this.menu.addItemAt(_loc41_,5);
         _loc42_ = new CateCoryInfo();
         _loc42_.ID = WISHBEAD;
         _loc42_.Name = LanguageMgr.GetTranslation("tank.auctionHouse.view.wishBead");
         _loc43_ = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),_loc42_);
         this.menu.addItemAt(_loc43_,5);
         this.list.invalidateViewport();
      }
      
      private function getMainCateInfo(param1:int, param2:String) : CateCoryInfo
      {
         var _loc3_:CateCoryInfo = new CateCoryInfo();
         _loc3_.ID = param1;
         _loc3_.Name = param2;
         return _loc3_;
      }
      
      private function _nameKeyUp(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ENTER)
         {
            AuctionHouseModel._dimBooble = false;
            this.__searchGoods(false);
         }
      }
      
      private function _nameChange(param1:Event) : void
      {
         if(this._name.text.indexOf(LanguageMgr.GetTranslation("tank.auctionHouse.view.pleaseInputOnThere")) > -1)
         {
            this._name.text = this._name.text.replace(LanguageMgr.GetTranslation("tank.auctionHouse.view.pleaseInputOnThere"),"");
         }
      }
      
      private function _clickStage(param1:MouseEvent) : void
      {
         var _loc2_:int = this._dimListArr.length - 1;
         while(_loc2_ >= 0)
         {
            if(this._dimListArr[_loc2_].parent)
            {
               this._dimListArr[_loc2_].dispose();
            }
            _loc2_--;
         }
         this._dimListArr = new Array();
      }
      
      private function __selectedDrop(param1:Event) : void
      {
         AuctionHouseModel._dimBooble = false;
         this.__searchGoods(false);
      }
      
      public function get searchText() : String
      {
         return this._searchValue;
      }
      
      public function set setSearchStatus(param1:Boolean) : void
      {
         this.searchStatus = param1;
      }
      
      public function set searchText(param1:String) : void
      {
         this._name.text = param1;
         this._searchValue = param1;
      }
      
      private function __searchCondition(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         AuctionHouseModel._dimBooble = false;
         this.__searchGoods(false);
      }
      
      private function __searchGoods(param1:Boolean = false) : void
      {
         this._isForAll = param1;
         AuctionHouseModel._dimBooble = false;
         this._clickStage(new MouseEvent("*"));
         if(this._name.text == LanguageMgr.GetTranslation("tank.auctionHouse.view.pleaseInputOnThere"))
         {
            this._name.text = "";
         }
         this._dictionary = new Dictionary();
         this._searchValue = "";
         this._name.text = this._trim(this._name.text);
         this._searchValue = this._name.text;
         AuctionHouseModel.searchType = 2;
         dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.SELECT_STRIP));
         this._name.stage.focus = FilterFrameText(this._name);
         var _loc2_:int = this._dimListArr.length - 1;
         while(_loc2_ >= 0)
         {
            if(this._dimListArr[_loc2_].parent)
            {
               this._dimListArr[_loc2_].parent.removeChild(this._dimListArr[_loc2_]);
            }
            _loc2_--;
         }
         this._dimListArr = new Array();
      }
      
      private function __searchGoodsII(param1:Boolean = false) : void
      {
         this._isForAll = param1;
         AuctionHouseModel._dimBooble = false;
         this._clickStage(new MouseEvent("*"));
         this._dictionary = new Dictionary();
         this._searchValue = "";
         AuctionHouseModel.searchType = 2;
         dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.SELECT_STRIP));
         var _loc2_:int = this._dimListArr.length - 1;
         while(_loc2_ >= 0)
         {
            if(this._dimListArr[_loc2_].parent)
            {
               this._dimListArr[_loc2_].parent.removeChild(this._dimListArr[_loc2_]);
            }
            _loc2_--;
         }
         this._dimListArr = new Array();
      }
      
      private function _trim(param1:String) : String
      {
         if(!param1)
         {
            return param1;
         }
         return param1.replace(/(^\s*)|(\s*$)/g,"");
      }
      
      private function menuItemClick(param1:Event) : void
      {
         this.list.invalidateViewport();
         if(this.menu.isseach)
         {
            AuctionHouseModel._dimBooble = false;
            this.__searchGoodsII();
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(this._searchBtn)
         {
            this._searchBtn.removeEventListener(MouseEvent.CLICK,this.__searchCondition);
         }
         if(this.menu)
         {
            this.menu.removeEventListener(VerticalMenu.MENU_CLICKED,this.menuItemClick);
            this.menu.dispose();
            this.menu = null;
         }
         if(this.list)
         {
            ObjectUtils.disposeObject(this.list);
            this.list = null;
         }
         if(this._name)
         {
            ObjectUtils.disposeObject(this._name);
         }
         this._name = null;
         if(this._searchBtn)
         {
            ObjectUtils.disposeObject(this._searchBtn);
         }
         this._searchBtn = null;
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
