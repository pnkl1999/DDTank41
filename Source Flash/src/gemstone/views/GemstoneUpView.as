package gemstone.views
{
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.cell.PersonalInfoCell;
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.BagEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import com.pickgliss.ui.controls.FTextButton;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import gemstone.GemstoneManager;
   import gemstone.info.GemstListInfo;
   import gemstone.info.GemstnoeSendInfo;
   import gemstone.info.GemstonInitInfo;
   import gemstone.info.GemstoneStaticInfo;
   import gemstone.info.GemstoneUpGradeInfo;
   import gemstone.items.ExpBar;
   import gemstone.items.GemstoneBuyItem;
   import gemstone.items.GemstoneContent;
   import org.aswing.KeyboardManager;
   
   public class GemstoneUpView extends Frame
   {
      
      private static const ANGLE_P:int = 120;
      
      private static const FIG_POS:int = 2;
       
      
      private var baseMc:MovieClip;
      
      private var _contArray:Vector.<GemstoneContent>;
      
      private var _centerP:Point;
      
      private var _angle:int = 0;
      
      private var _upgradeBtn:SimpleBitmapButton;
      
      private var _cellPos:Array;
      
      private var _cells:Vector.<PersonalInfoCell>;
      
      private var _cellContent:Sprite;
      
      private var _selfInfo:SelfInfo;
      
      private var _radius:Number = 100;
      
      private var _contArrlen:int;
      
      private var _expBar:ExpBar;
      
      private var _hairBtn:FTextButton;
      
      private var _faceBtn:FTextButton;
      
      private var _eyeBtn:FTextButton;
      
      private var _suitBtn:FTextButton;
      
      private var _decorateBtn:FTextButton;
      
      private var _selectBtn:SelectedButton;
      
      private var _txt1:FilterFrameText;
      
      private var _txt2:FilterFrameText;
      
      private var _txt3:FilterFrameText;
      
      private var _txt4:FilterFrameText;
      
      private var _selectTxt:FilterFrameText;
      
      private var _mouseClick:FilterFrameText;
      
      private var _bg:Bitmap;
      
      private var _gemstoneCriView:GemstoneCriView;
      
      private var _isAutoSele:int;
      
      private var _dataList:Vector.<InventoryItemInfo>;
      
      private var _sendInfo:GemstnoeSendInfo;
      
      private var _equipPlayce:int = 2;
      
      private var _fightSpiritId:int;
      
      private var statiDataList:Vector.<GemstoneStaticInfo>;
      
      private var _gemstoneInfoView:GemstoneInfoView;
      
      private var _gemstoneCurInfo:GemstoneCurInfo;
      
      public var curIndex:int;
      
      private var _bagitem:BagCell;
      
      private var _seletedBitMap:Bitmap;
      
      private var buyItem:GemstoneBuyItem;
      
      private var _btnContent:Sprite;
      
      public function GemstoneUpView(param1:SelfInfo)
      {
         this._dataList = new Vector.<InventoryItemInfo>();
         this._selfInfo = param1;
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         var _loc1_:InventoryItemInfo = null;
         this._expBar = ComponentFactory.Instance.creatComponentByStylename("expBar");
         addChild(this._expBar);
         if(GemstoneManager.Instance.hariList.length > 0)
         {
            this._fightSpiritId = GemstoneManager.Instance.hariList[0].fightSpiritId;
         }
         this._gemstoneInfoView = new GemstoneInfoView();
         this._gemstoneInfoView.x = 376;
         this._gemstoneInfoView.y = 15;
         addChild(this._gemstoneInfoView);
         _loc1_ = this._selfInfo == null?null:this._selfInfo.Bag.getItemAt(GemstoneManager.HariPPLACE);
         this._gemstoneCurInfo = new GemstoneCurInfo();
         this._gemstoneCurInfo.x = 365;
         this._gemstoneCurInfo.y = 22;
         this._gemstoneCriView = new GemstoneCriView();
         this._gemstoneCriView.x = 232;
         this._gemstoneCriView.y = 209;
         this._gemstoneCriView.staticDataList = GemstoneManager.Instance.redInfoList;
         this._gemstoneCriView.upDataIcon(_loc1_);
         this._gemstoneCriView.initFigSkin("gemstone.attckBig");
         addChild(this._gemstoneCriView);
         this._gemstoneCriView.resetGemstoneList(GemstoneManager.Instance.hariList);
         this._upgradeBtn = ComponentFactory.Instance.creatComponentByStylename("upgradeButton");
         this._btnContent = new Sprite();
         this._btnContent.x = 0;
         this._btnContent.y = 1;
         addChild(this._btnContent);
         this._hairBtn = new FTextButton("gemstone.yellow","gemstoneBtnTxt");
         this._hairBtn.x = 25;
         this._hairBtn.y = 29;
         this._hairBtn.setTxt(LanguageMgr.GetTranslation("ddt.gemstone.upview.hair"));
         this._hairBtn.id = 1;
         this._hairBtn.addEventListener(MouseEvent.CLICK,this.btnClickHander);
         this._faceBtn = new FTextButton("gemstone.yellow","gemstoneBtnTxt");
         this._faceBtn.x = 87;
         this._faceBtn.y = 29;
         this._faceBtn.setTxt(LanguageMgr.GetTranslation("ddt.gemstone.upview.face"));
         this._faceBtn.id = 2;
         this._faceBtn.addEventListener(MouseEvent.CLICK,this.btnClickHander);
         this._eyeBtn = new FTextButton("gemstone.yellow","gemstoneBtnTxt");
         this._eyeBtn.x = 147;
         this._eyeBtn.y = 29;
         this._eyeBtn.setTxt(LanguageMgr.GetTranslation("ddt.gemstone.upview.eye"));
         this._eyeBtn.id = 3;
         this._eyeBtn.addEventListener(MouseEvent.CLICK,this.btnClickHander);
         this._suitBtn = new FTextButton("gemstone.yellow2","gemstoneBtnTxt2");
         this._suitBtn.x = 208;
         this._suitBtn.y = 29;
         this._suitBtn.setTxt(LanguageMgr.GetTranslation("ddt.gemstone.upview.suit"));
         this._suitBtn.id = 4;
         this._suitBtn.addEventListener(MouseEvent.CLICK,this.btnClickHander);
         this._decorateBtn = new FTextButton("gemstone.yellow","gemstoneBtnTxt");
         this._decorateBtn.x = 288;
         this._decorateBtn.y = 29;
         this._decorateBtn.setTxt(LanguageMgr.GetTranslation("ddt.gemstone.upview.decorate"));
         this._decorateBtn.id = 5;
         this._decorateBtn.addEventListener(MouseEvent.CLICK,this.btnClickHander);
         this._txt1 = ComponentFactory.Instance.creatComponentByStylename("zhanhunDescript");
         this._txt1.text = LanguageMgr.GetTranslation("ddt.gemstone.upview.txt1");
         this._txt1.x = 26;
         this._txt1.y = 330;
         addChild(this._txt1);
         this._txt2 = ComponentFactory.Instance.creatComponentByStylename("writhTxt");
         this._txt2.text = LanguageMgr.GetTranslation("ddt.gemstone.upview.txt2");
         this._txt2.x = 172;
         this._txt2.y = 330;
         addChild(this._txt2);
         this._txt4 = ComponentFactory.Instance.creatComponentByStylename("zhanhunDescript");
         this._txt4.x = 30;
         this._txt4.y = 333;
         this._txt4.text = LanguageMgr.GetTranslation("ddt.gemstone.upview.txt4");
         addChild(this._txt4);
         this._selectTxt = ComponentFactory.Instance.creatComponentByStylename("selectUpGrade");
         this._selectTxt.text = LanguageMgr.GetTranslation("ddt.gemstone.upview.txt5");
         addChild(this._selectTxt);
         this._mouseClick = ComponentFactory.Instance.creatComponentByStylename("mouseClick");
         this._mouseClick.text = LanguageMgr.GetTranslation("ddt.gemstone.upview.txt6");
         addChild(this._mouseClick);
         this._upgradeBtn.addEventListener(MouseEvent.CLICK,this.mouseClickHander);
         this._btnContent.addChild(this._hairBtn);
         this._btnContent.addChild(this._faceBtn);
         this._btnContent.addChild(this._eyeBtn);
         this._btnContent.addChild(this._suitBtn);
         this._btnContent.addChild(this._decorateBtn);
         addChild(this._upgradeBtn);
         this._selectBtn = ComponentFactory.Instance.creatComponentByStylename("gemstone.selectedBtn");
         this._selectBtn.addEventListener(MouseEvent.CLICK,this.selectHander);
         addChild(this._selectBtn);
         this.visibleGroup1(false);
         this.visibleGroup2(true);
         var _loc2_:Sprite = new Sprite();
         var _loc3_:ItemTemplateInfo = ItemManager.Instance.getTemplateById(100100);
         this._bagitem = new BagCell(0,_loc3_);
         this._bagitem.x = 32;
         this._bagitem.y = 280;
         addChild(this._bagitem);
         this.upDatafitCount();
         this.buyItem = new GemstoneBuyItem();
         this.buyItem.x = 82;
         this.buyItem.y = 310;
         this.buyItem.setup(100100,5);
         addChild(this.buyItem);
         this.buyItem.visible = false;
         this._seletedBitMap = ComponentFactory.Instance.creatBitmap("gemstone.seleted");
         this._seletedBitMap.x = this._hairBtn.x - 2;
         this._seletedBitMap.y = this._hairBtn.y - 2;
         this._btnContent.addChild(this._seletedBitMap);
      }
      
      protected function updateCount(param1:BagEvent) : void
      {
         this.upDatafitCount();
      }
      
      public function upDatafitCount() : void
      {
         if(!this._bagitem)
         {
            return;
         }
         var _loc1_:BagInfo = this._selfInfo.getBag(BagInfo.PROPBAG);
         var _loc2_:int = _loc1_.getItemCountByTemplateId(100100);
         _loc2_ = _loc2_ + _loc1_.getItemCountByTemplateId(201264);
         this._bagitem.setCount(_loc2_);
      }
      
      private function visibleGroup1(param1:Boolean) : void
      {
         this._mouseClick.visible = param1;
         this._selectTxt.visible = param1;
         this._gemstoneInfoView.visible = param1;
      }
      
      private function visibleGroup2(param1:Boolean) : void
      {
         this._txt1.visible = param1;
         this._txt2.visible = param1;
         this._txt4.visible = param1;
         this._gemstoneCurInfo.visible = param1;
         this._expBar.visible = param1;
         this._selectBtn.visible = param1;
         this._gemstoneInfoView.visible = param1;
      }
      
      public function get expBar() : ExpBar
      {
         return this._expBar;
      }
      
      protected function selectHander(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._selectBtn.selected)
         {
            this._isAutoSele = 1;
         }
         else
         {
            this._isAutoSele = 0;
         }
      }
      
      protected function btnClickHander(param1:MouseEvent) : void
      {
         var _loc2_:ItemTemplateInfo = null;
         var _loc3_:GemstonInitInfo = null;
         var _loc4_:Vector.<GemstListInfo> = null;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         SoundManager.instance.play("008");
         this.visibleGroup1(false);
         this.visibleGroup2(true);
         if(param1.currentTarget.id == 1)
         {
            _loc2_ = this._selfInfo == null?null:this._selfInfo.Bag.getItemAt(GemstoneManager.HariPPLACE);
            if(GemstoneManager.Instance.hariList.length > 0)
            {
               _loc4_ = GemstoneManager.Instance.hariList;
               this._fightSpiritId = GemstoneManager.Instance.hariList[0].fightSpiritId;
            }
            this._equipPlayce = GemstoneManager.HariPPLACE;
            _loc6_ = "gemstone.attckBig";
            GemstoneManager.Instance.curstatiDataList = GemstoneManager.Instance.redInfoList;
         }
         else if(param1.currentTarget.id == 2)
         {
            _loc2_ = this._selfInfo == null?null:this._selfInfo.Bag.getItemAt(GemstoneManager.FacePLACE);
            if(GemstoneManager.Instance.faceList.length > 0)
            {
               _loc4_ = GemstoneManager.Instance.faceList;
               this._fightSpiritId = GemstoneManager.Instance.faceList[0].fightSpiritId;
            }
            this._equipPlayce = GemstoneManager.FacePLACE;
            _loc6_ = "gemstone.luckyBig";
            GemstoneManager.Instance.curstatiDataList = GemstoneManager.Instance.yelInfoList;
         }
         else if(param1.currentTarget.id == 3)
         {
            _loc2_ = this._selfInfo == null?null:this._selfInfo.Bag.getItemAt(GemstoneManager.GlassPPLACE);
            if(GemstoneManager.Instance.glassList.length > 0)
            {
               _loc4_ = GemstoneManager.Instance.glassList;
               this._fightSpiritId = GemstoneManager.Instance.glassList[0].fightSpiritId;
            }
            this._equipPlayce = GemstoneManager.GlassPPLACE;
            _loc6_ = "gemstone.agileBig";
            GemstoneManager.Instance.curstatiDataList = GemstoneManager.Instance.greInfoList;
         }
         else if(param1.currentTarget.id == 4)
         {
            _loc2_ = this._selfInfo == null?null:this._selfInfo.Bag.getItemAt(GemstoneManager.SuitPLACE);
            if(GemstoneManager.Instance.suitList.length > 0)
            {
               _loc4_ = GemstoneManager.Instance.suitList;
               this._fightSpiritId = GemstoneManager.Instance.suitList[0].fightSpiritId;
            }
            this._equipPlayce = GemstoneManager.SuitPLACE;
            _loc6_ = "gemstone.defenseBig";
            GemstoneManager.Instance.curstatiDataList = GemstoneManager.Instance.bluInfoList;
         }
         else if(param1.currentTarget.id == 5)
         {
            _loc2_ = this._selfInfo == null?null:this._selfInfo.Bag.getItemAt(GemstoneManager.DecorationPLACE);
            if(GemstoneManager.Instance.decorationList.length > 0)
            {
               _loc4_ = GemstoneManager.Instance.decorationList;
               this._fightSpiritId = GemstoneManager.Instance.decorationList[0].fightSpiritId;
            }
            this._equipPlayce = GemstoneManager.DecorationPLACE;
            _loc6_ = "gemstone.hpBig";
            GemstoneManager.Instance.curstatiDataList = GemstoneManager.Instance.purpleInfoList;
         }
         this._gemstoneCriView.place = this._equipPlayce;
         this._gemstoneCriView.staticDataList = GemstoneManager.Instance.curstatiDataList;
         this._gemstoneCriView.initFigSkin(_loc6_);
         this._gemstoneCriView.upDataIcon(_loc2_);
         if(_loc4_)
         {
            this._gemstoneCriView.resetGemstoneList(_loc4_);
         }
         this._seletedBitMap.x = param1.currentTarget.x - 2;
         this._seletedBitMap.y = param1.currentTarget.y - 2;
         this._seletedBitMap.width = param1.currentTarget.width + 3;
      }
      
      private function mouseClickHander(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:int = 10010001;
         var _loc3_:int = 201264;
         var _loc4_:BagInfo = this._selfInfo.getBag(BagInfo.PROPBAG);
         var _loc5_:int = _loc4_.getItemCountByTemplateId(_loc3_);
         if(_loc5_ > 0)
         {
            this.sendFigSpiritUpGrade(_loc2_,_loc3_);
         }
         if(!(_loc5_ > 0 && this._isAutoSele == 0))
         {
            _loc2_ = 10010001;
            _loc3_ = 100100;
            _loc5_ = _loc5_ + _loc4_.getItemCountByTemplateId(_loc3_);
            if(_loc5_ > 0)
            {
               this.sendFigSpiritUpGrade(_loc2_,_loc3_);
            }
         }
      }
      
      private function sendFigSpiritUpGrade(param1:int, param2:int) : void
      {
         GemstoneManager.Instance.gemstoneFrame.getMaskMc().visible = true;
         KeyboardManager.getInstance().isStopDispatching = true;
         SoundManager.instance.play("170");
         var _loc3_:GemstnoeSendInfo = new GemstnoeSendInfo();
         _loc3_.autoBuyId = this._isAutoSele;
         _loc3_.goodsId = param1;
         _loc3_.type = 1;
         _loc3_.templeteId = param2;
         _loc3_.fightSpiritId = this._fightSpiritId;
         _loc3_.equipPlayce = this._equipPlayce;
         _loc3_.place = FIG_POS;
         SocketManager.Instance.out.figSpiritUpGrade(_loc3_);
      }
      
      public function gemstoneAction(param1:GemstoneUpGradeInfo) : void
      {
         this._gemstoneCriView.upGradeAction(param1);
      }
      
      public function upDataCur(param1:Object) : void
      {
         this._gemstoneCurInfo.update(param1);
      }
      
      override public function dispose() : void
      {
         this._gemstoneCriView.dispose();
         PlayerManager.Instance.removeEventListener(BagEvent.GEMSTONE_BUG_COUNT,this.updateCount);
         this._upgradeBtn.removeEventListener(MouseEvent.CLICK,this.mouseClickHander);
         this._decorateBtn.removeEventListener(MouseEvent.CLICK,this.btnClickHander);
         this._hairBtn.removeEventListener(MouseEvent.CLICK,this.btnClickHander);
         this._faceBtn.removeEventListener(MouseEvent.CLICK,this.btnClickHander);
         this._eyeBtn.removeEventListener(MouseEvent.CLICK,this.btnClickHander);
         this._suitBtn.removeEventListener(MouseEvent.CLICK,this.btnClickHander);
         this._selectBtn.removeEventListener(MouseEvent.CLICK,this.selectHander);
         if(this._upgradeBtn)
         {
            ObjectUtils.disposeObject(this._upgradeBtn);
         }
         this._upgradeBtn = null;
         if(this._decorateBtn)
         {
            ObjectUtils.disposeObject(this._decorateBtn);
         }
         this._decorateBtn = null;
         if(this._hairBtn)
         {
            ObjectUtils.disposeObject(this._hairBtn);
         }
         this._hairBtn = null;
         if(this._faceBtn)
         {
            ObjectUtils.disposeObject(this._faceBtn);
         }
         this._faceBtn = null;
         if(this._eyeBtn)
         {
            ObjectUtils.disposeObject(this._eyeBtn);
         }
         this._eyeBtn = null;
         if(this._suitBtn)
         {
            ObjectUtils.disposeObject(this._suitBtn);
         }
         this._suitBtn = null;
         if(this._selectBtn)
         {
            ObjectUtils.disposeObject(this._selectBtn);
         }
         this._selectBtn = null;
         if(this._gemstoneCriView)
         {
            ObjectUtils.disposeObject(this._gemstoneCriView);
         }
         this._gemstoneCriView = null;
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(this._txt1)
         {
            ObjectUtils.disposeObject(this._txt1);
         }
         this._txt1 = null;
         if(this._txt2)
         {
            ObjectUtils.disposeObject(this._txt2);
         }
         this._txt2 = null;
         if(this._txt3)
         {
            ObjectUtils.disposeObject(this._txt3);
         }
         this._txt3 = null;
         if(this._txt4)
         {
            ObjectUtils.disposeObject(this._txt4);
         }
         this._txt4 = null;
         if(this._expBar)
         {
            ObjectUtils.disposeObject(this._expBar);
         }
         this._expBar = null;
         if(this._seletedBitMap)
         {
            ObjectUtils.disposeObject(this._seletedBitMap);
         }
         this._seletedBitMap = null;
      }
   }
}
