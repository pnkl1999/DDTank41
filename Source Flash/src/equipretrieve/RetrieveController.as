package equipretrieve
{
   import bagAndInfo.BagAndInfoManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.BagEvent;
   import ddt.manager.PlayerManager;
   import equipretrieve.view.RetrieveBagcell;
   
   public class RetrieveController
   {
      
      private static var _instance:RetrieveController;
       
      
      private var _viewMouseEvtBoolean:Boolean = true;
      
      private var _view:RetrieveFrame;
      
      private var _isBagOpen:Boolean;
      
      public function RetrieveController()
      {
         super();
      }
      
      public static function get Instance() : RetrieveController
      {
         if(_instance == null)
         {
            _instance = new RetrieveController();
         }
         return _instance;
      }
      
      public function start() : void
      {
         this._addEvt();
         RetrieveModel.Instance.start(PlayerManager.Instance.Self);
         this._view = ComponentFactory.Instance.creatCustomObject("retrieve.retrieveFrame");
         this._view.show();
         BagAndInfoManager.Instance.hideBagAndInfo();
      }
      
      public function close() : void
      {
         this._removeEvt();
         if(this._view)
         {
            ObjectUtils.disposeObject(this._view);
         }
         RetrieveModel.Instance.replay();
         this._view = null;
         if(!this._isBagOpen)
         {
            return;
         }
         BagAndInfoManager.Instance.showBagAndInfo();
         this._isBagOpen = false;
      }
      
      public function set isBagOpen(param1:Boolean) : void
      {
         this._isBagOpen = param1;
      }
      
      public function get isBagOpen() : Boolean
      {
         return this._isBagOpen;
      }
      
      public function get view() : RetrieveFrame
      {
         return this._view;
      }
      
      public function get viewMouseEvtBoolean() : Boolean
      {
         return this._viewMouseEvtBoolean;
      }
      
      public function set viewMouseEvtBoolean(param1:Boolean) : void
      {
         if(this._view)
         {
            this._viewMouseEvtBoolean = param1;
            this._view.mouseChildren = param1;
            this._view.mouseEnabled = param1;
         }
      }
      
      public function set shine(param1:Boolean) : void
      {
         if(this._view)
         {
            this._view.shine = param1;
         }
      }
      
      public function set retrieveType(param1:int) : void
      {
         this._view.bagType = param1;
      }
      
      private function _addEvt() : void
      {
         PlayerManager.Instance.Self.StoreBag.addEventListener(BagEvent.UPDATE,this._updateStoreBag);
      }
      
      private function _removeEvt() : void
      {
         PlayerManager.Instance.Self.StoreBag.removeEventListener(BagEvent.UPDATE,this._updateStoreBag);
      }
      
      private function _updateStoreBag(param1:BagEvent) : void
      {
         if(this._view)
         {
            this._view.updateBag(param1.changedSlots);
         }
      }
      
      public function cellDoubleClick(param1:RetrieveBagcell) : void
      {
         this._view.cellDoubleClick(param1);
      }
   }
}
