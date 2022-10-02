package tryonSystem
{
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.manager.LanguageMgr;
   
   public class TryonPanelFrame extends BaseAlerFrame
   {
       
      
      private var _control:TryonSystemController;
      
      private var _view:TryonPanelView;
      
      public function TryonPanelFrame()
      {
         super();
         var _loc1_:AlertInfo = new AlertInfo(LanguageMgr.GetTranslation("ddt.tryonSystem.title"),"","",true,false);
         _loc1_.submitLabel = LanguageMgr.GetTranslation("ok");
         _loc1_.moveEnable = false;
         info = _loc1_;
      }
      
      public function set controller(param1:TryonSystemController) : void
      {
         this._control = param1;
         this.initView();
      }
      
      public function initView() : void
      {
         this._view = new TryonPanelView(this._control);
         this._view.x = -8;
         this._view.y = -6;
         addToContent(this._view);
      }
      
      override public function dispose() : void
      {
         this._view.dispose();
         this._view = null;
         this._control = null;
         super.dispose();
      }
   }
}
