package equipDebt.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import equipDebt.EquipDebtManager;
   
   public class EquipDebtFrame extends BaseAlerFrame
   {
       
      
      private var _alertInfo:AlertInfo;
      
      private var _equipList:VBox;
      
      private var _equipScroll:ScrollPanel;
      
      private var _tileText:FilterFrameText;
      
      public function EquipDebtFrame()
      {
         super();
         this.initialize();
      }
      
      protected function initialize() : void
      {
         this.setView();
         this.setEvent();
      }
      
      private function setView() : void
      {
         submitButtonStyle = "core.simplebt";
         this._alertInfo = new AlertInfo(LanguageMgr.GetTranslation("tank.view.task.TaskCatalogContentView.tip"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,false);
         this._alertInfo.moveEnable = false;
         info = this._alertInfo;
         this.escEnable = true;
         this._tileText = ComponentFactory.Instance.creatComponentByStylename("EquipDebtText");
         this._tileText.text = "wellpastdue";
         this._equipList = new VBox();
         this._equipScroll = ComponentFactory.Instance.creatComponentByStylename("EquipDebtItemList");
         this._equipScroll.setView(this._equipList);
         this._equipScroll.vScrollProxy = ScrollPanel.ON;
         this._equipList.strictSize = 66;
         this._equipList.isReverAdd = true;
         addToContent(this._tileText);
         addToContent(this._equipScroll);
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.NONE_BLOCKGOUND);
      }
      
      public function setList(param1:Array) : void
      {
         var _loc3_:EquipItem = null;
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = new EquipItem();
            _loc3_.info = param1[_loc2_];
            this._equipList.addChild(_loc3_);
            _loc2_++;
         }
         this._equipScroll.invalidateViewport();
      }
      
      private function removeView() : void
      {
         super.dispose();
      }
      
      private function setEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
      }
      
      private function onFrameResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               EquipDebtManager.Instance.dispose();
               break;
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               this.dispose();
               EquipDebtManager.Instance.openEquipDebt();
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         this.removeView();
      }
   }
}
