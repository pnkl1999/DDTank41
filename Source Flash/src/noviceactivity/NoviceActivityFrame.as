package noviceactivity
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   
   public class NoviceActivityFrame extends Frame
   {
       
      
      private var _leftview:NoviceActivityLeftView;
      
      private var _rightview:NoviceActivityRightView;
      
      public function NoviceActivityFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         NoviceActivityManager.instance.currentRightType = 1;
         _titleText = LanguageMgr.GetTranslation("noviceactivity.mainframe.title");
         this._leftview = new NoviceActivityLeftView();
         PositionUtils.setPos(this._leftview,"noviceactivity.mainframe.leftview.pos");
         addToContent(this._leftview);
         this._rightview = new NoviceActivityRightView();
         PositionUtils.setPos(this._rightview,"noviceactivity.mainframe.rightview.pos");
         addToContent(this._rightview);
         this._rightview.setInfo(NoviceActivityManager.instance.recordList[0],NoviceActivityManager.instance.list[0]);
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.ESC_CLICK || param1.responseCode == FrameEvent.CLOSE_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      public function setRightView(param1:NoviceActivityInfo, param2:NoviceActivityInfo) : void
      {
         if(this._rightview)
         {
            this._rightview.setInfo(param1,param2);
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         super.dispose();
         if(this._leftview)
         {
            ObjectUtils.disposeObject(this._leftview);
         }
         this._leftview = null;
         if(this._rightview)
         {
            ObjectUtils.disposeObject(this._rightview);
         }
         this._rightview = null;
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
