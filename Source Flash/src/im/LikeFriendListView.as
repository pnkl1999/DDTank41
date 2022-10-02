package im
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.ListItemEvent;
   import com.pickgliss.geom.IntPoint;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ListPanel;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.analyze.LikeFriendAnalyzer;
   import ddt.data.player.LikeFriendInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.utils.RequestVairableCreater;
   import flash.display.Sprite;
   import flash.net.URLVariables;
   
   public class LikeFriendListView extends Sprite implements Disposeable
   {
       
      
      private var _list:ListPanel;
      
      private var _likeFriendList:Array;
      
      private var _currentItem:LikeFriendInfo;
      
      private var _pos:int;
      
      public function LikeFriendListView()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         this._list = ComponentFactory.Instance.creatComponentByStylename("IM.LikeFriendListPanel");
         this._list.vScrollProxy = ScrollPanel.AUTO;
         addChild(this._list);
         this._list.list.updateListView();
         if(IMController.Instance.likeFriendList != null)
         {
            this._likeFriendList = IMController.Instance.likeFriendList;
            this.__updateList();
         }
         this.creatItemTempleteLoader();
      }
      
      private function initEvents() : void
      {
         this._list.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__itemClick);
      }
      
      private function removeEvents() : void
      {
         this._list.list.removeEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__itemClick);
      }
      
      private function creatItemTempleteLoader() : BaseLoader
      {
         var _loc1_:URLVariables = RequestVairableCreater.creatWidthKey(true);
         _loc1_["selfid"] = PlayerManager.Instance.Self.ID;
         var _loc2_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("SameCityIMLoad.ashx"),BaseLoader.REQUEST_LOADER,_loc1_);
         _loc2_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingLikeFriendTemplateFailure");
         _loc2_.analyzer = new LikeFriendAnalyzer(this.__loadComplete);
         _loc2_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         LoaderManager.Instance.startLoad(_loc2_);
         return _loc2_;
      }
      
      private function __onLoadError(param1:LoaderEvent) : void
      {
         var _loc2_:String = param1.loader.loadErrorMessage;
         if(param1.loader.analyzer)
         {
            if(param1.loader.analyzer.message != null)
            {
               _loc2_ = param1.loader.loadErrorMessage + "\n" + param1.loader.analyzer.message;
            }
         }
         var _loc3_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("alert"),_loc2_,LanguageMgr.GetTranslation("tank.room.RoomIIView2.affirm"));
         _loc3_.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
      }
      
      private function __onAlertResponse(param1:FrameEvent) : void
      {
         ObjectUtils.disposeObject(param1.currentTarget);
      }
      
      private function __loadComplete(param1:LikeFriendAnalyzer) : void
      {
         this._likeFriendList = IMController.Instance.likeFriendList = param1.likeFriendList;
         this.__updateList();
      }
      
      private function __itemClick(param1:ListItemEvent) : void
      {
         if(!this._currentItem)
         {
            this._currentItem = param1.cellValue as LikeFriendInfo;
            this._currentItem.isSelected = true;
         }
         else if(this._currentItem != param1.cellValue as LikeFriendInfo)
         {
            this._currentItem.isSelected = false;
            this._currentItem = param1.cellValue as LikeFriendInfo;
            this._currentItem.isSelected = true;
         }
         this._list.list.updateListView();
      }
      
      private function __updateList() : void
      {
         if(this._list == null)
         {
            return;
         }
         this._pos = this._list.list.viewPosition.y;
         this.update();
         var _loc1_:IntPoint = new IntPoint(0,this._pos);
         this._list.list.viewPosition = _loc1_;
      }
      
      private function update() : void
      {
         var _loc4_:LikeFriendInfo = null;
         var _loc1_:Array = [];
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         while(_loc3_ < this._likeFriendList.length)
         {
            _loc4_ = this._likeFriendList[_loc3_];
            if(_loc4_.IsVIP)
            {
               _loc1_.push(_loc4_);
            }
            else
            {
               _loc2_.push(_loc4_);
            }
            _loc3_++;
         }
         _loc1_ = _loc1_.sortOn("Grade",Array.NUMERIC | Array.DESCENDING);
         _loc2_ = _loc2_.sortOn("Grade",Array.NUMERIC | Array.DESCENDING);
         this._likeFriendList = _loc1_.concat(_loc2_);
         this._list.vectorListModel.clear();
         this._list.vectorListModel.appendAll(this._likeFriendList);
         this._list.list.updateListView();
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         if(this._list)
         {
            ObjectUtils.disposeObject(this._list);
         }
         this._list = null;
         this._likeFriendList = null;
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
