package totem.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.BitmapFilterQuality;
   import flash.filters.ColorMatrixFilter;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import totem.TotemManager;
   import totem.data.TotemDataVo;
   
   public class TotemLeftWindowView extends Sprite implements Disposeable
   {
       
      
      private var _bg:Bitmap;
      
      private var _bgList:Vector.<Bitmap>;
      
      private var _totemPointBgList:Vector.<BitmapData>;
      
      private var _totemPointIconList:Vector.<BitmapData>;
      
      private var _totemPointSprite:Sprite;
      
      private var _totemPointList:Vector.<TotemLeftWindowTotemCell>;
      
      private var _curCanClickPointLocation:int;
      
      private var _totemPointLocationList:Array;
      
      private var _windowBorder:Bitmap;
      
      private var _lineShape:Shape;
      
      private var _lightGlowFilter:GlowFilter;
      
      private var _grayGlowFilter:ColorMatrixFilter;
      
      private var _openCartoonSprite:TotemLeftWindowOpenCartoonView;
      
      private var _propertyTxtSprite:TotemLeftWindowPropertyTxtView;
      
      private var _tipView:TotemPointTipView;
      
      private var _chapterIcon:TotemLeftWindowChapterIcon;
      
      public function TotemLeftWindowView()
      {
         this._totemPointLocationList = [[{
            "x":300,
            "y":300
         },{
            "x":100,
            "y":300
         },{
            "x":100,
            "y":100
         },{
            "x":200,
            "y":200
         },{
            "x":300,
            "y":100
         },{
            "x":450,
            "y":150
         },{
            "x":450,
            "y":300
         }],[{
            "x":100,
            "y":100
         },{
            "x":100,
            "y":300
         },{
            "x":200,
            "y":200
         },{
            "x":300,
            "y":300
         },{
            "x":450,
            "y":300
         },{
            "x":450,
            "y":150
         },{
            "x":300,
            "y":100
         }],[{
            "x":100,
            "y":200
         },{
            "x":150,
            "y":100
         },{
            "x":250,
            "y":200
         },{
            "x":150,
            "y":300
         },{
            "x":350,
            "y":300
         },{
            "x":450,
            "y":200
         },{
            "x":350,
            "y":100
         }],[{
            "x":100,
            "y":300
         },{
            "x":100,
            "y":100
         },{
            "x":250,
            "y":150
         },{
            "x":250,
            "y":300
         },{
            "x":400,
            "y":300
         },{
            "x":450,
            "y":200
         },{
            "x":350,
            "y":100
         }],[{
            "x":300,
            "y":300
         },{
            "x":200,
            "y":200
         },{
            "x":100,
            "y":300
         },{
            "x":100,
            "y":100
         },{
            "x":300,
            "y":100
         },{
            "x":450,
            "y":300
         },{
            "x":450,
            "y":150
         }]];
         super();
         this.init();
      }
      
      private function init() : void
      {
         var _loc1_:int = 0;
         this._windowBorder = ComponentFactory.Instance.creatBitmap("asset.totem.leftView.windowBorder");
         this._windowBorder.smoothing = true;
         addChild(this._windowBorder);
         this._bgList = new Vector.<Bitmap>();
         _loc1_ = 1;
         while(_loc1_ <= 5)
         {
            this._bgList.push(ComponentFactory.Instance.creatBitmap("asset.totem.leftView.windowBg" + _loc1_));
            _loc1_++;
         }
         this._totemPointBgList = new Vector.<BitmapData>();
         _loc1_ = 1;
         while(_loc1_ <= 5)
         {
            this._totemPointBgList.push(ComponentFactory.Instance.creatBitmapData("asset.totem.totemPointBg" + _loc1_));
            _loc1_++;
         }
         this._totemPointIconList = new Vector.<BitmapData>();
         _loc1_ = 1;
         while(_loc1_ <= 7)
         {
            this._totemPointIconList.push(ComponentFactory.Instance.creatBitmapData("asset.totem.totemPointIcon" + _loc1_));
            _loc1_++;
         }
         this._openCartoonSprite = new TotemLeftWindowOpenCartoonView(this._totemPointLocationList,this.refreshGlowFilter,this.refreshTotemPoint);
         this._propertyTxtSprite = new TotemLeftWindowPropertyTxtView();
         this._lineShape = new Shape();
         addChild(this._lineShape);
         this._lightGlowFilter = new GlowFilter(52479,1,20,20,2,BitmapFilterQuality.MEDIUM);
         this._grayGlowFilter = new ColorMatrixFilter([0.3,0.59,0.11,0,0,0.3,0.59,0.11,0,0,0.3,0.59,0.11,0,0,0,0,0,1,0]);
         this._tipView = new TotemPointTipView();
         this._tipView.visible = false;
         LayerManager.Instance.addToLayer(this._tipView,LayerManager.GAME_TOP_LAYER);
         this._chapterIcon = ComponentFactory.Instance.creatCustomObject("totem.totemChapterIcon");
      }
      
      public function refreshView(param1:TotemDataVo, param2:Function = null) : void
      {
         this._openCartoonSprite.refreshView(param1,param2);
      }
      
      public function openFailHandler(param1:TotemDataVo) : void
      {
         this._openCartoonSprite.failRefreshView(param1,this.enableCurCanClickBtn);
      }
      
      private function enableCurCanClickBtn() : void
      {
         if(this._curCanClickPointLocation != 0 && this._totemPointList)
         {
            this._totemPointList[this._curCanClickPointLocation - 1].mouseChildren = true;
            this._totemPointList[this._curCanClickPointLocation - 1].mouseEnabled = true;
         }
      }
      
      private function disenableCurCanClickBtn() : void
      {
         if(this._curCanClickPointLocation != 0 && this._totemPointList)
         {
            this._totemPointList[this._curCanClickPointLocation - 1].mouseChildren = false;
            this._totemPointList[this._curCanClickPointLocation - 1].mouseEnabled = false;
         }
      }
      
      public function show(param1:int, param2:TotemDataVo, param3:Boolean) : void
      {
         if(param1 == 0)
         {
            param1 = 1;
         }
         if(this._bg)
         {
            removeChild(this._bg);
         }
         this._bg = this._bgList[param1 - 1];
         addChildAt(this._bg,0);
         this.drawLine(param1,param2,param3);
         this.addTotemPoint(this._totemPointLocationList[param1 - 1],param1,param2,param3);
         addChild(this._openCartoonSprite);
         addChild(this._propertyTxtSprite);
         addChild(this._chapterIcon);
         this._chapterIcon.show(param1);
      }
      
      private function addTotemPoint(param1:Array, param2:int, param3:TotemDataVo, param4:Boolean) : void
      {
         var _loc6_:int = 0;
         var _loc5_:TotemLeftWindowTotemCell = null;
         _loc6_ = 0;
         _loc5_ = null;
         _loc6_ = 0;
         var _loc7_:TotemLeftWindowTotemCell = null;
         var _loc8_:Bitmap = null;
         var _loc9_:Bitmap = null;
         _loc5_ = null;
         if(this._totemPointSprite)
         {
            if(this._curCanClickPointLocation != 0 && this._totemPointList)
            {
               this._totemPointList[this._curCanClickPointLocation - 1].useHandCursor = false;
               this._totemPointList[this._curCanClickPointLocation - 1].removeEventListener(MouseEvent.CLICK,this.openTotem);
               this._totemPointList[this._curCanClickPointLocation - 1].removeEventListener(MouseEvent.MOUSE_OVER,this.showTip);
               this._totemPointList[this._curCanClickPointLocation - 1].removeEventListener(MouseEvent.MOUSE_OUT,this.hideTip);
               this._curCanClickPointLocation = 0;
            }
            if(this._totemPointSprite.parent)
            {
               this._totemPointSprite.parent.removeChild(this._totemPointSprite);
            }
            this._totemPointSprite = null;
         }
         if(this._totemPointList)
         {
            for each(_loc7_ in this._totemPointList)
            {
               _loc7_.removeEventListener(MouseEvent.MOUSE_OVER,this.showTip);
               _loc7_.removeEventListener(MouseEvent.MOUSE_OUT,this.hideTip);
               ObjectUtils.disposeObject(_loc7_);
            }
            this._totemPointList = null;
         }
         this._totemPointSprite = new Sprite();
         this._totemPointList = new Vector.<TotemLeftWindowTotemCell>();
         var _loc10_:BitmapData = this._totemPointBgList[param2 - 1];
         var _loc11_:int = param1.length;
         _loc6_ = 0;
         while(_loc6_ < _loc11_)
         {
            _loc8_ = new Bitmap(_loc10_,"auto",true);
            _loc9_ = new Bitmap(this._totemPointIconList[_loc6_],"auto",true);
            _loc5_ = new TotemLeftWindowTotemCell(_loc8_,_loc9_);
            _loc5_.x = param1[_loc6_].x - 46;
            _loc5_.y = param1[_loc6_].y - 53;
            _loc5_.addEventListener(MouseEvent.MOUSE_OVER,this.showTip,false,0,true);
            _loc5_.addEventListener(MouseEvent.MOUSE_OUT,this.hideTip,false,0,true);
            _loc5_.index = _loc6_ + 1;
            _loc5_.isCurCanClick = false;
            this._totemPointSprite.addChild(_loc5_);
            this._totemPointList.push(_loc5_);
            _loc6_++;
         }
         this._propertyTxtSprite.show(param1);
         this.refreshTotemPoint(param2,param3,param4);
         addChild(this._totemPointSprite);
      }
      
      private function refreshGlowFilter(param1:int, param2:TotemDataVo) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = this._totemPointList.length;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if(!param2 || param1 < param2.Page || _loc3_ + 1 < param2.Location)
            {
               this._totemPointList[_loc3_].setBgIconSpriteFilter([this._lightGlowFilter]);
               this._totemPointList[_loc3_].isHasLighted = true;
            }
            else
            {
               this._totemPointList[_loc3_].setBgIconSpriteFilter([this._grayGlowFilter]);
               this._totemPointList[_loc3_].isHasLighted = false;
            }
            _loc3_++;
         }
      }
      
      private function refreshTotemPoint(param1:int, param2:TotemDataVo, param3:Boolean) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         _loc4_ = 0;
         _loc5_ = 0;
         this.drawLine(param1,param2,param3);
         this.refreshGlowFilter(param1,param2);
         if(this._curCanClickPointLocation != 0)
         {
            _loc4_ = this._curCanClickPointLocation - 1;
            this._totemPointList[_loc4_].dimOutHalo();
            this._totemPointList[_loc4_].hideLigthCross();
            this._totemPointList[_loc4_].removeEventListener(MouseEvent.CLICK,this.openTotem);
            this._totemPointList[_loc4_].useHandCursor = false;
            this._totemPointList[_loc4_].buttonMode = false;
            this._totemPointList[_loc4_].mouseChildren = true;
            this._totemPointList[_loc4_].mouseEnabled = true;
            this._totemPointList[_loc4_].isCurCanClick = false;
            this._curCanClickPointLocation = 0;
         }
         if(param3 && param2 && param1 == param2.Page)
         {
            _loc5_ = param2.Location - 1;
            this._totemPointList[_loc5_].brightenHalo();
            this._totemPointList[_loc5_].showLigthCross();
            this._totemPointList[_loc5_].useHandCursor = true;
            this._totemPointList[_loc5_].buttonMode = true;
            this._totemPointList[_loc5_].mouseChildren = true;
            this._totemPointList[_loc5_].mouseEnabled = true;
            this._totemPointList[_loc5_].addEventListener(MouseEvent.CLICK,this.openTotem,false,0,true);
            this._totemPointList[_loc5_].isCurCanClick = true;
            this._curCanClickPointLocation = param2.Location;
         }
         if(!param2 || param1 < param2.Page)
         {
            _loc6_ = param1 * 10;
         }
         else
         {
            _loc6_ = (param1 - 1) * 10 + param2.Layers;
         }
         this._propertyTxtSprite.refreshLayer(_loc6_);
         var _loc7_:int = this._totemPointList.length;
         var _loc8_:int = 0;
         while(_loc8_ < _loc7_)
         {
            this._totemPointList[_loc8_].level = _loc6_;
            _loc8_++;
         }
      }
      
      public function scalePropertyTxtSprite(param1:Number) : void
      {
         if(this._propertyTxtSprite)
         {
            this._propertyTxtSprite.scaleTxt(param1);
         }
      }
      
      private function openTotem(param1:MouseEvent) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:BaseAlerFrame = null;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc5_:TotemDataVo = TotemManager.instance.getNextInfoById(PlayerManager.Instance.Self.totemId);
         var _loc6_:int = PlayerManager.Instance.Self.getBag(BagInfo.PROPBAG).getItemCountByTemplateId(TotemSignTxtCell.TOTEM_SIGN,true);
         _loc3_ = Math.round(_loc5_.ConsumeExp * (ServerConfigManager.instance.totemSignDiscount / 100));
         if(_loc6_ > _loc3_)
         {
            _loc6_ = _loc3_;
         }
         if(PlayerManager.Instance.Self.myHonor < _loc5_.ConsumeHonor || PlayerManager.Instance.Self.Money + _loc6_ < _loc5_.ConsumeExp)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.totem.honorOrExpUnenough"));
            return;
         }
         if(TotemManager.instance.isSelectedActPro)
         {
            if(TotemManager.instance.isDonotPromptActPro)
            {
               if(_loc5_.Random < 100 && TotemManager.instance.isBindInNoPrompt && PlayerManager.Instance.Self.Gift < 1000)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortiaBattle.buy.noEnoughBindMoneyTxt"));
                  TotemManager.instance.isDonotPromptActPro = false;
               }
               else
               {
                  if(!(_loc5_.Random < 100 && !TotemManager.instance.isBindInNoPrompt && PlayerManager.Instance.Self.Money < 1000))
                  {
                     this.doOpenOneTotem(TotemManager.instance.isBindInNoPrompt);
                     return;
                  }
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortiaBattle.buy.noEnoughMoneyTxt"));
                  TotemManager.instance.isDonotPromptActPro = false;
               }
            }
            _loc4_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.totem.activateProtectTipTxt2"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND,null,"TotemActProConfirmFrame",30,true);
            _loc4_.moveEnable = false;
            _loc4_.addEventListener(FrameEvent.RESPONSE,this.__openOneTotemConfirm,false,0,true);
         }
         else
         {
            this.doOpenOneTotem(false);
         }
      }
      
      private function __openOneTotemConfirm(param1:FrameEvent) : void
      {
         var _loc2_:TotemDataVo = null;
         SoundManager.instance.play("008");
         var _loc3_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc3_.removeEventListener(FrameEvent.RESPONSE,this.__openOneTotemConfirm);
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            _loc2_ = TotemManager.instance.getNextInfoById(PlayerManager.Instance.Self.totemId);
            if(_loc2_.Random < 100 && _loc3_.isBand && PlayerManager.Instance.Self.Gift < 1000)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortiaBattle.buy.noEnoughBindMoneyTxt"));
               return;
            }
            if(_loc2_.Random < 100 && !_loc3_.isBand && PlayerManager.Instance.Self.Money < 1000)
            {
               LeavePageManager.showFillFrame();
               return;
            }
            if((_loc3_ as TotemActProConfirmFrame).isNoPrompt)
            {
               TotemManager.instance.isDonotPromptActPro = true;
               TotemManager.instance.isBindInNoPrompt = _loc3_.isBand;
            }
            this.doOpenOneTotem(_loc3_.isBand);
         }
      }
      
      private function doOpenOneTotem(param1:Boolean) : void
      {
         this.disenableCurCanClickBtn();
         SocketManager.Instance.out.sendOpenOneTotem(TotemManager.instance.isSelectedActPro,param1);
      }
      
      private function showTip(param1:MouseEvent) : void
      {
         var _loc2_:TotemLeftWindowTotemCell = null;
         var _loc3_:Point = null;
         _loc2_ = param1.currentTarget as TotemLeftWindowTotemCell;
         _loc3_ = this.localToGlobal(new Point(_loc2_.x + _loc2_.bgIconWidth + 10,_loc2_.y));
         this._tipView.x = _loc3_.x;
         this._tipView.y = _loc3_.y;
         var _loc4_:TotemDataVo = TotemManager.instance.getCurInfoByLevel((_loc2_.level - 1) * 7 + _loc2_.index);
         this._tipView.show(_loc4_,_loc2_.isCurCanClick,_loc2_.isHasLighted);
         this._tipView.visible = true;
      }
      
      private function hideTip(param1:MouseEvent) : void
      {
         this._tipView.visible = false;
      }
      
      private function drawTestPoint() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Shape = new Shape();
         var _loc3_:int = 1;
         while(_loc3_ <= 7)
         {
            _loc1_ = 1;
            while(_loc1_ <= 10)
            {
               _loc2_.graphics.beginFill(16711680,0.6);
               _loc2_.graphics.drawCircle(_loc1_ * 50,_loc3_ * 50,10);
               _loc2_.graphics.endFill();
               _loc1_++;
            }
            _loc3_++;
         }
         addChild(_loc2_);
      }
      
      private function drawLine(param1:int, param2:TotemDataVo, param3:Boolean) : void
      {
         this._lineShape.graphics.clear();
         var _loc4_:Array = this._totemPointLocationList[param1 - 1];
         var _loc5_:int = 0;
         if(!param2 || param1 < param2.Page)
         {
            _loc5_ = _loc4_.length;
         }
         else if(param3)
         {
            _loc5_ = param2.Location;
         }
         else
         {
            _loc5_ = param2.Location;
         }
         this._lineShape.graphics.lineStyle(2.7,4321279,0.2);
         this._lineShape.graphics.moveTo(_loc4_[0].x,_loc4_[0].y);
         var _loc6_:int = 1;
         while(_loc6_ < _loc5_)
         {
            this._lineShape.graphics.lineTo(_loc4_[_loc6_].x,_loc4_[_loc6_].y);
            _loc6_++;
         }
         this._lineShape.filters = [new GlowFilter(65532,1,8,8)];
      }
      
      public function dispose() : void
      {
         var _loc1_:BitmapData = null;
         var _loc2_:BitmapData = null;
         var _loc3_:TotemLeftWindowTotemCell = null;
         ObjectUtils.disposeAllChildren(this);
         for each(_loc1_ in this._totemPointBgList)
         {
            _loc1_.dispose();
         }
         this._totemPointBgList = null;
         for each(_loc2_ in this._totemPointIconList)
         {
            _loc2_.dispose();
         }
         this._totemPointIconList = null;
         this._totemPointSprite = null;
         if(this._curCanClickPointLocation != 0 && this._totemPointList)
         {
            this._totemPointList[this._curCanClickPointLocation - 1].useHandCursor = false;
            this._totemPointList[this._curCanClickPointLocation - 1].removeEventListener(MouseEvent.CLICK,this.openTotem);
            this._curCanClickPointLocation = 0;
         }
         if(this._totemPointList)
         {
            for each(_loc3_ in this._totemPointList)
            {
               _loc3_.removeEventListener(MouseEvent.MOUSE_OVER,this.showTip);
               _loc3_.removeEventListener(MouseEvent.MOUSE_OUT,this.hideTip);
               ObjectUtils.disposeObject(_loc3_);
            }
         }
         this._totemPointList = null;
         this._lineShape = null;
         this._lightGlowFilter = null;
         this._grayGlowFilter = null;
         this._bg = null;
         this._bgList = null;
         this._windowBorder = null;
         this._propertyTxtSprite = null;
         ObjectUtils.disposeObject(this._tipView);
         this._tipView = null;
         ObjectUtils.disposeObject(this._openCartoonSprite);
         this._openCartoonSprite = null;
         ObjectUtils.disposeObject(this._chapterIcon);
         this._chapterIcon = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
