package lightRoad.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import lightRoad.Item.GiftItem;
   import lightRoad.data.LightRoadPackageType;
   import lightRoad.info.LightCartoonInfo;
   import lightRoad.info.LightGiftInfo;
   import lightRoad.manager.LightRoadManager;
   
   public class MainFrame extends Frame
   {
       
      
      private var _helpBtn:BaseButton;
      
      private var _Bg:Bitmap;
      
      private var _giftItem:Vector.<GiftItem>;
      
      private var _ThingsBox:Sprite;
      
      private var _dayShowText:FilterFrameText;
      
      private var _mC12:MovieClip;
      
      private var _mC34:MovieClip;
      
      private var _mC56:MovieClip;
      
      private var _mC78:MovieClip;
      
      private var _mC89:MovieClip;
      
      private var _mC1011:MovieClip;
      
      private var _mC1213:MovieClip;
      
      private var _mC17:MovieClip;
      
      private var _cartoon:Vector.<LightCartoonInfo>;
      
      public function MainFrame()
      {
         super();
         this.initView();
         this.initEvent();
         this.initText();
         this.upFrameDataShow();
      }
      
      private function initView() : void
      {
         this._Bg = ComponentFactory.Instance.creatBitmap("asset.lightroad.swf.backGround.png");
         this._helpBtn = ComponentFactory.Instance.creat("lightroad.help.btn");
         this._dayShowText = ComponentFactory.Instance.creatComponentByStylename("lightRoad.gift.DayTxt");
         addToContent(this._Bg);
         this._ThingsBox = new Sprite();
         addToContent(this._ThingsBox);
         addToContent(this._helpBtn);
         addToContent(this._dayShowText);
      }
      
      private function initText() : void
      {
         titleText = LanguageMgr.GetTranslation("lightRoad.MainFrame.TitleText");
      }
      
      private function upDayShowText() : void
      {
         this._dayShowText.text = LanguageMgr.GetTranslation("lightRoad.MainFrame.DayText") + " " + LightRoadManager.instance.model.ActivityStartTime + " - " + LightRoadManager.instance.model.ActivityEndTime;
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._helpBtn.addEventListener(MouseEvent.CLICK,this.__createHelpFrame);
         LightRoadManager.instance.addEventListener(CrazyTankSocketEvent.LIGHTROAD_SYSTEM,this.__dealWhithLightRoadEvent);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._helpBtn.removeEventListener(MouseEvent.CLICK,this.__createHelpFrame);
         LightRoadManager.instance.removeEventListener(CrazyTankSocketEvent.LIGHTROAD_SYSTEM,this.__dealWhithLightRoadEvent);
      }
      
      private function __dealWhithLightRoadEvent(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = param1._cmd;
         switch(_loc2_)
         {
            case LightRoadPackageType.UPMAINFRAMEDATA:
               this.upFrameDataShow();
         }
      }
      
      private function upFrameDataShow() : void
      {
         this.checkCartoon();
         this.initGiftItem();
         this.upDayShowText();
      }
      
      private function checkCartoon() : void
      {
         this.removeAllCartoon();
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Boolean = false;
         var _loc6_:int = 0;
         _loc2_ = LightRoadManager.instance.model.pointGroup.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = LightRoadManager.instance.model.pointGroup[_loc1_][1].length;
            _loc6_ = LightRoadManager.instance.model.pointGroup[_loc1_][0] - 1;
            if(LightRoadManager.instance.model.thingsType[_loc6_] == 0)
            {
               _loc5_ = true;
               _loc3_ = 0;
               while(_loc3_ < _loc4_)
               {
                  _loc6_ = LightRoadManager.instance.model.pointGroup[_loc1_][1][_loc3_] - 1;
                  if(LightRoadManager.instance.model.thingsType[_loc6_] == 0)
                  {
                     _loc5_ = false;
                     break;
                  }
                  _loc3_++;
               }
               if(_loc5_)
               {
                  this.createCartoon(String(LightRoadManager.instance.model.pointGroup[_loc1_][0]));
               }
            }
            _loc1_++;
         }
      }
      
      private function createCartoon(param1:String) : void
      {
         if(this._cartoon == null)
         {
            this._cartoon = new Vector.<LightCartoonInfo>();
         }
         var _loc2_:LightCartoonInfo = new LightCartoonInfo(param1);
         this._cartoon.push(_loc2_);
         addToContent(_loc2_.MC);
      }
      
      private function removeAllCartoon() : void
      {
         var _loc1_:LightCartoonInfo = null;
         if(this._cartoon)
         {
            while(this._cartoon.length)
            {
               _loc1_ = this._cartoon[0] as LightCartoonInfo;
               _loc1_.dispose();
               this._cartoon.shift();
            }
         }
      }
      
      private function initGiftItem() : void
      {
         var _loc2_:int = 0;
         var _loc4_:GiftItem = null;
         _loc2_ = 0;
         var _loc3_:LightGiftInfo = null;
         _loc4_ = null;
         var _loc1_:int = 0;
         _loc2_ = 0;
         if(this._giftItem == null)
         {
            this._giftItem = new Vector.<GiftItem>();
            _loc1_ = LightRoadManager.instance.model.thingsArray.length;
            _loc2_ = 0;
            while(true)
            {
               if(_loc2_ < _loc1_)
               {
                  if(LightRoadManager.instance.model.thingsArray[_loc2_] != undefined)
                  {
                     continue;
                  }
               }
            }
         }
         else
         {
            _loc1_ = this._giftItem.length;
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               this._giftItem[_loc2_].upData();
               _loc2_++;
            }
         }
      }
      
      private function removeGiftItem() : void
      {
         while(this._giftItem.length)
         {
            ObjectUtils.disposeObject(this._giftItem[0]);
            this._giftItem.shift();
         }
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LIGHTROAD_SYSTEM,null,LightRoadPackageType.CLOSEMAINFRAME));
         }
      }
      
      private function __createHelpFrame(param1:MouseEvent) : void
      {
         dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LIGHTROAD_SYSTEM,null,LightRoadPackageType.OPENHELPRAME));
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         this.removeGiftItem();
         this.removeAllCartoon();
         ObjectUtils.disposeAllChildren(this);
         super.dispose();
         this._ThingsBox = null;
         this._Bg = null;
         this._helpBtn = null;
      }
   }
}
