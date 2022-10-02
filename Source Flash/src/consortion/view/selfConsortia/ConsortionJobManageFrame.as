package consortion.view.selfConsortia
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import consortion.ConsortionModelControl;
   import consortion.data.ConsortiaDutyInfo;
   import consortion.event.ConsortionEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   
   public class ConsortionJobManageFrame extends Frame
   {
       
      
      private var _bg:Bitmap;
      
      private var _levelExplain:ScaleFrameImage;
      
      private var _cancel:TextButton;
      
      private var _list:VBox;
      
      private var _items:Vector.<JobManageItem>;
      
      public function ConsortionJobManageFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         escEnable = true;
         disposeChildren = true;
         titleText = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaRightsFrame.titleText");
         this._bg = ComponentFactory.Instance.creatBitmap("asset.consortion.jobManage.bg");
         this._levelExplain = ComponentFactory.Instance.creatComponentByStylename("consortion.jobManage.levelExplain");
         this._list = ComponentFactory.Instance.creatComponentByStylename("consortion.jobManage.list");
         this._cancel = ComponentFactory.Instance.creatComponentByStylename("consortion.jobManage.cancel");
         addToContent(this._bg);
         addToContent(this._levelExplain);
         addToContent(this._list);
         addToContent(this._cancel);
         this._cancel.text = LanguageMgr.GetTranslation("close");
         this._items = new Vector.<JobManageItem>(5);
         this.setDataList(ConsortionModelControl.Instance.model.dutyList);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._cancel.addEventListener(MouseEvent.CLICK,this.__cancelHandler);
         ConsortionModelControl.Instance.model.addEventListener(ConsortionEvent.DUTY_LIST_CHANGE,this.__dutyListChange);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._cancel.removeEventListener(MouseEvent.CLICK,this.__cancelHandler);
         ConsortionModelControl.Instance.model.removeEventListener(ConsortionEvent.DUTY_LIST_CHANGE,this.__dutyListChange);
         var _loc1_:int = 0;
         while(_loc1_ < 5)
         {
            this._items[_loc1_].removeEventListener(MouseEvent.CLICK,this.__itemClickHandler);
            _loc1_++;
         }
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      private function __cancelHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.dispose();
      }
      
      private function __dutyListChange(param1:ConsortionEvent) : void
      {
         this.setDataList(ConsortionModelControl.Instance.model.dutyList);
      }
      
      private function setDataList(param1:Vector.<ConsortiaDutyInfo>) : void
      {
         var _loc2_:int = 0;
         this.clearList();
         if(param1)
         {
            _loc2_ = 0;
            while(_loc2_ < param1.length)
            {
               this._items[_loc2_] = new JobManageItem();
               this._items[_loc2_].dutyInfo = param1[_loc2_];
               this._items[_loc2_].name = String(_loc2_);
               this._items[_loc2_].addEventListener(MouseEvent.CLICK,this.__itemClickHandler);
               this._list.addChild(this._items[_loc2_]);
               _loc2_++;
            }
         }
         this._levelExplain.setFrame(1);
      }
      
      private function clearList() : void
      {
         this._list.disposeAllChildren();
         var _loc1_:int = 0;
         while(_loc1_ < 5)
         {
            this._items[_loc1_] = null;
            _loc1_++;
         }
      }
      
      private function __itemClickHandler(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < 5)
         {
            if(param1.currentTarget != this._items[_loc2_])
            {
               this._items[_loc2_].selected = false;
               this._items[_loc2_].editable = false;
            }
            else
            {
               this._items[_loc2_].selected = true;
               this._levelExplain.setFrame(_loc2_ + 1);
            }
            _loc2_++;
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         this.clearList();
         super.dispose();
         this._bg = null;
         this._levelExplain = null;
         this._cancel = null;
         this._list = null;
         this._items = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
