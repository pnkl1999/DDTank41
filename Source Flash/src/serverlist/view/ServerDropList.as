package serverlist.view
{
   import com.pickgliss.events.ListItemEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ComboBox;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.list.VectorListModel;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.ServerInfo;
   import ddt.loader.StartupResourceLoader;
   import ddt.manager.ServerManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   
   public class ServerDropList extends Frame
   {
       
      
      protected var _expanded:Boolean;
      
      protected var _bg:Bitmap;
      
      private var _loader:BaseLoader;
      
      protected var _cb:ComboBox;
      
      public function ServerDropList()
      {
         super();
         this._expanded = false;
         this.initView();
         this.initEvent();
         this.updateList();
         this._cb.textField.text = ServerManager.Instance.current.Name;
      }
      
      protected function initView() : void
      {
         this._bg = ComponentFactory.Instance.creat("asset.serverlist.hallBG");
         addChild(this._bg);
         this._cb = ComponentFactory.Instance.creat("serverlist.hall.DropListCombo");
         addChild(this._cb);
      }
      
      protected function initEvent() : void
      {
         this._cb.listPanel.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__onListClicked);
         this._cb.addEventListener(MouseEvent.CLICK,this.__onClicked);
      }
      
      private function __onClicked(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         this.updateServerList();
      }
      
      protected function __onStageClicked(param1:MouseEvent) : void
      {
         this.hideList();
         this._expanded = false;
      }
      
      private function __onListClicked(param1:ListItemEvent) : void
      {
         SoundManager.instance.playButtonSound();
         var _loc2_:ServerInfo = this.getServerByName(param1.cellValue);
         if(ServerManager.Instance.connentServer(_loc2_) == false)
         {
            this.refresh();
         }
         else
         {
            this._cb.mouseChildren = false;
         }
      }
      
      private function updateServerList() : void
      {
         var _loc2_:ServerInfo = null;
         var _loc1_:VectorListModel = this._cb.listPanel.vectorListModel;
         _loc1_.clear();
         for each(_loc2_ in this.getServerList())
         {
            _loc1_.append(_loc2_.Name);
         }
      }
      
      protected function getServerList() : Vector.<ServerInfo>
      {
         var _loc3_:ServerInfo = null;
         var _loc1_:Vector.<ServerInfo> = ServerManager.Instance.list;
         var _loc2_:Vector.<ServerInfo> = new Vector.<ServerInfo>();
         for each(_loc3_ in _loc1_)
         {
            if(_loc3_.Name != ServerManager.Instance.current.Name)
            {
               if(_loc3_.State != ServerInfo.MAINTAIN)
               {
                  _loc2_.push(_loc3_);
               }
            }
         }
         return _loc2_;
      }
      
      public function hideList() : void
      {
      }
      
      private function getServerByName(param1:String) : ServerInfo
      {
         var _loc3_:ServerInfo = null;
         var _loc2_:Vector.<ServerInfo> = ServerManager.Instance.list;
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.Name == param1)
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      public function refresh() : void
      {
         this._cb.mouseChildren = true;
         this.updateList();
         this._cb.textField.text = ServerManager.Instance.current.Name;
      }
      
      public function updateList() : void
      {
         this._loader = StartupResourceLoader.Instance.creatServerListLoader();
         this._loader.addEventListener(LoaderEvent.COMPLETE,this.__onListLoadComplete);
         LoaderManager.Instance.startLoad(this._loader);
      }
      
      public function __onListLoadComplete(param1:LoaderEvent) : void
      {
         this._loader.removeEventListener(LoaderEvent.COMPLETE,this.__onListLoadComplete);
         this.updateServerList();
         this._cb.textField.text = ServerManager.Instance.current.Name;
      }
      
      override public function dispose() : void
      {
         this._loader.removeEventListener(LoaderEvent.COMPLETE,this.__onListLoadComplete);
         this._loader = null;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         if(this._cb)
         {
            this._cb.listPanel.list.removeEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__onListClicked);
            this._cb.removeEventListener(MouseEvent.CLICK,this.__onClicked);
            this._cb.dispose();
         }
         this._cb = null;
         super.dispose();
      }
   }
}
