package baglocked
{
   import baglocked.data.BagLockedInfo;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.manager.SocketManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class BagLockedController extends EventDispatcher
   {
      
      public static var TEMP_PWD:String = "";
      
      public static var PWD:String = "";
       
      
      private var _explainFrame:ExplainFrame;
      
      private var _setPassFrame1:SetPassFrame1;
      
      private var _setPassFrame2:SetPassFrame2;
      
      private var _setPassFrame3:SetPassFrame3;
      
      private var _setPassFrameNew:SetPassFrameNew;
      
      private var _delPassFrame:DelPassFrame;
      
      private var _bagLockedGetFrame:BagLockedGetFrame;
      
      private var _updatePassFrame:UpdatePassFrame;
      
      private var _visible:Boolean = false;
      
      private var _bagLockedInfo:BagLockedInfo;
      
      private var _currentFn:Function;
      
      public function BagLockedController()
      {
         super();
      }
      
      public function set bagLockedInfo(param1:BagLockedInfo) : void
      {
         this._bagLockedInfo = param1;
      }
      
      public function get bagLockedInfo() : BagLockedInfo
      {
         if(!this._bagLockedInfo)
         {
            this._bagLockedInfo = new BagLockedInfo();
         }
         return this._bagLockedInfo;
      }
      
      private function loadUi(param1:Function) : void
      {
         this._currentFn = param1;
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__uiProgress);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__uiComplete);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.BAGLOCKED);
      }
      
      private function __onClose(param1:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__uiProgress);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__uiComplete);
      }
      
      private function __uiProgress(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.BAGLOCKED)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      private function __uiComplete(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.BAGLOCKED)
         {
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__uiProgress);
            param1.currentTarget.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__uiComplete);
            UIModuleSmallLoading.Instance.hide();
            if(this._currentFn != null)
            {
               this._currentFn();
            }
            this._currentFn = null;
         }
      }
      
      public function show() : void
      {
         this.loadUi(this.onShow);
      }
      
      private function onShow() : void
      {
         if(!this._explainFrame)
         {
            this._explainFrame = ComponentFactory.Instance.creat("baglocked.explainFrame");
            this._explainFrame.bagLockedController = this;
            this._explainFrame.show();
         }
         else
         {
            this.close();
         }
      }
      
      public function closeExplainFrame() : void
      {
         ObjectUtils.disposeObject(this._explainFrame);
         this._explainFrame = null;
      }
      
      public function openSetPassFrame1() : void
      {
         this._setPassFrame1 = ComponentFactory.Instance.creat("baglocked.setPassFrame1");
         this._setPassFrame1.bagLockedController = this;
         this._setPassFrame1.show();
      }
      
      public function closeSetPassFrame1() : void
      {
         ObjectUtils.disposeObject(this._setPassFrame1);
         this._setPassFrame1 = null;
      }
      
      public function openSetPassFrame2() : void
      {
         this._setPassFrame2 = ComponentFactory.Instance.creat("baglocked.setPassFrame2");
         this._setPassFrame2.bagLockedController = this;
         this._setPassFrame2.show();
      }
      
      public function closeSetPassFrame2() : void
      {
         ObjectUtils.disposeObject(this._setPassFrame2);
         this._setPassFrame2 = null;
      }
      
      public function openSetPassFrame3() : void
      {
         this._setPassFrame3 = ComponentFactory.Instance.creat("baglocked.setPassFrame3");
         this._setPassFrame3.bagLockedController = this;
         this._setPassFrame3.show();
      }
      
      public function closeSetPassFrame3() : void
      {
         ObjectUtils.disposeObject(this._setPassFrame3);
         this._setPassFrame3 = null;
      }
      
      public function setPassComplete() : void
      {
         SocketManager.Instance.out.sendBagLocked(this._bagLockedInfo.psw,1,"",this._bagLockedInfo.questionOne,this._bagLockedInfo.answerOne,this._bagLockedInfo.questionTwo,this._bagLockedInfo.answerTwo);
         this._bagLockedInfo = null;
      }
      
      public function openBagLockedGetFrame() : void
      {
         this.loadUi(this.onOpenBagLockedGetFrame);
      }
      
      private function onOpenBagLockedGetFrame() : void
      {
         if(this._bagLockedGetFrame == null)
         {
            this._bagLockedGetFrame = ComponentFactory.Instance.creat("baglocked.bagLockedGetFrame");
            this._bagLockedGetFrame.bagLockedController = this;
         }
         this._bagLockedGetFrame.show();
      }
      
      public function BagLockedGetFrameController() : void
      {
         SocketManager.Instance.out.sendBagLocked(this._bagLockedInfo.psw,2);
         this._bagLockedInfo = null;
      }
      
      public function closeBagLockedGetFrame() : void
      {
         this.close();
      }
      
      public function openUpdatePassFrame() : void
      {
         this._updatePassFrame = ComponentFactory.Instance.creat("baglocked.updatePassFrame");
         this._updatePassFrame.bagLockedController = this;
         this._updatePassFrame.show();
      }
      
      public function updatePassFrameController() : void
      {
         SocketManager.Instance.out.sendBagLocked(this._bagLockedInfo.psw,3,this._bagLockedInfo.newPwd);
         this._bagLockedInfo = null;
      }
      
      public function closeUpdatePassFrame() : void
      {
         this.close();
      }
      
      public function openDelPassFrame() : void
      {
         this._delPassFrame = ComponentFactory.Instance.creat("baglocked.delPassFrame");
         this._delPassFrame.bagLockedController = this;
         this._delPassFrame.show();
      }
      
      public function delPassFrameController() : void
      {
         SocketManager.Instance.out.sendBagLocked("",4,"",this._bagLockedInfo.questionOne,this._bagLockedInfo.answerOne,this._bagLockedInfo.questionTwo,this._bagLockedInfo.answerTwo);
         this._bagLockedInfo = null;
      }
      
      public function closeDelPassFrame() : void
      {
         this.close();
      }
      
      public function openSetPassFrameNew() : void
      {
         this._setPassFrameNew = ComponentFactory.Instance.creat("baglocked.setPassFrameNew");
         this._setPassFrameNew.bagLockedController = this;
         this._setPassFrameNew.show();
      }
      
      public function setPassFrameNewController() : void
      {
         SocketManager.Instance.out.sendBagLocked(this._bagLockedInfo.psw,1);
         this._bagLockedInfo = null;
      }
      
      public function closeSetPassFrameNew() : void
      {
         this.close();
      }
      
      public function close() : void
      {
         if(this._updatePassFrame)
         {
            ObjectUtils.disposeObject(this._updatePassFrame);
            this._updatePassFrame = null;
         }
         if(this._bagLockedGetFrame)
         {
            ObjectUtils.disposeObject(this._bagLockedGetFrame);
            this._bagLockedGetFrame = null;
         }
         if(this._delPassFrame)
         {
            ObjectUtils.disposeObject(this._delPassFrame);
            this._delPassFrame = null;
         }
         if(this._setPassFrameNew)
         {
            ObjectUtils.disposeObject(this._setPassFrameNew);
            this._setPassFrameNew = null;
         }
         if(this._setPassFrame3)
         {
            ObjectUtils.disposeObject(this._setPassFrame3);
            this._setPassFrame3 = null;
         }
         if(this._setPassFrame2)
         {
            ObjectUtils.disposeObject(this._setPassFrame2);
            this._setPassFrame2 = null;
         }
         if(this._setPassFrame1)
         {
            ObjectUtils.disposeObject(this._setPassFrame1);
            this._setPassFrame1 = null;
         }
         if(this._explainFrame)
         {
            ObjectUtils.disposeObject(this._explainFrame);
            this._explainFrame = null;
         }
         dispatchEvent(new Event(Event.COMPLETE));
      }
   }
}
