package totem.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import totem.HonorUpManager;
   import totem.data.HonorUpDataVo;
   
   public class HonorUpFrame extends Frame
   {
       
      
      private var _bg:Bitmap;
      
      private var _btnBg:Bitmap;
      
      private var _tip1:FilterFrameText;
      
      private var _tip2:FilterFrameText;
      
      private var _tip3:FilterFrameText;
      
      private var _upBtn:SimpleBitmapButton;
      
      private var _money:int;
      
      public function HonorUpFrame()
      {
         super();
         this.initView();
         this.initEvent();
         this.refreshShow(null);
      }
      
      private function initView() : void
      {
         titleText = LanguageMgr.GetTranslation("ddt.totem.honorUpFrame.titleTxt");
         this._bg = ComponentFactory.Instance.creatBitmap("asset.totem.honorUpFrame.mainBg");
         this._btnBg = ComponentFactory.Instance.creatBitmap("asset.totem.honorUpFrame.btnBg");
         this._tip1 = ComponentFactory.Instance.creatComponentByStylename("totem.honorUpFrame.tip1");
         this._tip2 = ComponentFactory.Instance.creatComponentByStylename("totem.honorUpFrame.tip2");
         this._tip3 = ComponentFactory.Instance.creatComponentByStylename("totem.honorUpFrame.tip3");
         this._upBtn = ComponentFactory.Instance.creatComponentByStylename("totem.honorUpFrame.upBtn");
         addToContent(this._bg);
         addToContent(this._btnBg);
         addToContent(this._tip1);
         addToContent(this._tip2);
         addToContent(this._tip3);
         addToContent(this._upBtn);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._upBtn.addEventListener(MouseEvent.CLICK,this.doUpHonor,false,0,true);
         HonorUpManager.instance.addEventListener(HonorUpManager.UP_COUNT_UPDATE,this.refreshShow,false,0,true);
      }
      
      private function refreshShow(param1:Event) : void
      {
         var _loc2_:HonorUpDataVo = null;
         var _loc3_:Array = HonorUpManager.instance.dataList;
         var _loc4_:int = HonorUpManager.instance.upCount;
         if(_loc4_ >= _loc3_.length)
         {
            this.dispose();
         }
         else
         {
            _loc2_ = _loc3_[_loc4_] as HonorUpDataVo;
            this._tip1.text = LanguageMgr.GetTranslation("ddt.totem.honorUpFrame.tip1");
            this._tip2.text = _loc2_.honor.toString();
            this._tip3.text = _loc2_.money.toString();
         }
      }
      
      private function doUpHonor(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:Array = HonorUpManager.instance.dataList;
         var _loc3_:int = HonorUpManager.instance.upCount;
         var _loc4_:int = (_loc2_[_loc3_] as HonorUpDataVo).money;
         if(this.checkMoney(false,_loc4_))
         {
            return;
         }
         SocketManager.Instance.out.sendHonorUp(2,false);
      }
      
      public function checkMoney(param1:Boolean, param2:int, param3:Function = null) : Boolean
      {
         this._money = param2;
         if(param1)
         {
            if(PlayerManager.Instance.Self.Gift < param2)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.view.giftLack"));
               return true;
            }
         }
         else if(PlayerManager.Instance.Self.Money < param2)
         {
            LeavePageManager.showFillFrame();
            return true;
         }
         return false;
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._upBtn.removeEventListener(MouseEvent.CLICK,this.doUpHonor);
         HonorUpManager.instance.removeEventListener(HonorUpManager.UP_COUNT_UPDATE,this.refreshShow);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._btnBg);
         this._btnBg = null;
         ObjectUtils.disposeObject(this._tip1);
         this._tip1 = null;
         ObjectUtils.disposeObject(this._tip2);
         this._tip2 = null;
         ObjectUtils.disposeObject(this._tip3);
         this._tip3 = null;
         ObjectUtils.disposeObject(this._upBtn);
         this._upBtn = null;
         super.dispose();
      }
   }
}
