package ddt.dailyRecord
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.Event;
   
   public class DailyRecordFrame extends Frame
   {
       
      
      private var _titleImg:Bitmap;
      
      private var _bg:Scale9CornerImage;
      
      private var _vbox:VBox;
      
      private var _list:ScrollPanel;
      
      public function DailyRecordFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         escEnable = true;
         disposeChildren = true;
         titleText = LanguageMgr.GetTranslation("ddt.dailyRecord.title");
         this._titleImg = ComponentFactory.Instance.creatBitmap("asset.core.dailyRecord.titleImg");
         this._bg = ComponentFactory.Instance.creatComponentByStylename("dailyRecord.bg");
         this._vbox = ComponentFactory.Instance.creatComponentByStylename("dailyRecord.vbox");
         this._list = ComponentFactory.Instance.creatComponentByStylename("dailyRecord.panel");
         addToContent(this._titleImg);
         addToContent(this._bg);
         addToContent(this._list);
         this._list.setView(this._vbox);
         this.setData(DailyRecordControl.Instance.recordList);
      }
      
      private function setData(param1:Vector.<DailiyRecordInfo>) : void
      {
         var _loc3_:DailyRecordItem = null;
         ObjectUtils.disposeAllChildren(this._vbox);
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = new DailyRecordItem();
            this._vbox.addChild(_loc3_);
            _loc3_.setData(_loc2_,param1[_loc2_]);
            _loc2_++;
         }
         this._list.invalidateViewport();
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         DailyRecordControl.Instance.addEventListener(DailyRecordControl.RECORDLIST_IS_READY,this.__dataIsOk);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         DailyRecordControl.Instance.removeEventListener(DailyRecordControl.RECORDLIST_IS_READY,this.__dataIsOk);
      }
      
      private function __dataIsOk(param1:Event) : void
      {
         this.setData(DailyRecordControl.Instance.recordList);
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.ESC_CLICK || param1.responseCode == FrameEvent.CLOSE_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         super.dispose();
         if(this._titleImg)
         {
            ObjectUtils.disposeObject(this._titleImg);
         }
         this._titleImg = null;
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(this._vbox)
         {
            ObjectUtils.disposeObject(this._vbox);
         }
         this._vbox = null;
         if(this._list)
         {
            ObjectUtils.disposeObject(this._list);
         }
         this._list = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
