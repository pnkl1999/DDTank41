package store
{
   import ddt.manager.PlayerManager;
   import flash.display.Sprite;
   import store.data.StoreModel;
   import store.states.BaseStoreView;
   import road7th.data.DictionaryData;
   
   public class StoreController
   {
       
      
      private var _type:String;
      
      private var _model:StoreModel;
	  
	  public var selectedIndex:DictionaryData;
      
      public function StoreController()
      {
         super();
         this.init();
         this.initEvents();
      }
      
      private function init() : void
      {
         this._model = new StoreModel(PlayerManager.Instance.Self);
		 this.selectedIndex = new DictionaryData();
      }
      
      private function initEvents() : void
      {
      }
      
      private function removeEvents() : void
      {
      }
      
      public function startupEvent() : void
      {
      }
      
      public function shutdownEvent() : void
      {
      }
      
      public function getView(param1:String) : Sprite
      {
         return new BaseStoreView(this,param1);
      }
      
      public function get Type() : String
      {
         return this._type;
      }
      
      public function get Model() : StoreModel
      {
         return this._model;
      }
      
      public function dispose() : void
      {
         this.shutdownEvent();
         this.removeEvents();
         this._model.clear();
         this._model = null;
		 this.selectedIndex = null;
      }
   }
}
