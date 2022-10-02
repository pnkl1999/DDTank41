package farm.viewx
{
   import com.greensock.TweenLite;
   import com.greensock.easing.Sine;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ListPanel;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.list.VectorListModel;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.FriendListPlayer;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import farm.FarmModelController;
   import farm.event.FarmEvent;
   import farm.modelx.FramFriendStateInfo;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import petsBag.controller.PetBagController;
   import petsBag.data.PetFarmGuildeTaskType;
   import road7th.data.DictionaryEvent;
   import trainer.data.ArrowType;
   
   public class FarmFriendListView extends Sprite implements Disposeable
   {
       
      
      private var _list:ListPanel;
      
      private var _switchAsset:ScaleFrameImage;
      
      private var isOpen:Boolean = true;
      
      private var _listBG:ScaleBitmapImage;
      
      private var _listBound:ScaleBitmapImage;
      
      private var _switchTween:TweenLite;
      
      public function FarmFriendListView()
      {
         super();
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         this._listBG = ComponentFactory.Instance.creatComponentByStylename("farm.friendListBg");
         addChild(this._listBG);
         this._listBound = ComponentFactory.Instance.creatComponentByStylename("farm.friendListBound");
         addChild(this._listBound);
         this._switchAsset = ComponentFactory.Instance.creatComponentByStylename("farm.listSwitch");
         this._switchAsset.buttonMode = true;
         if(this.isOpen)
         {
            this._switchAsset.setFrame(1);
         }
         addChild(this._switchAsset);
         this._list = ComponentFactory.Instance.creat("asset.farm.farmFriendListPanel");
         this._list.vScrollProxy = ScrollPanel.AUTO;
         addChild(this._list);
         this._list.list.updateListView();
         this.switchView();
         this.update();
      }
      
      private function initEvent() : void
      {
         PlayerManager.Instance.addEventListener(PlayerManager.FRIENDLIST_COMPLETE,this.__friendlistHandler);
         FarmModelController.instance.addEventListener(FarmEvent.FRIEND_INFO_READY,this.__infoReady);
         FarmModelController.instance.addEventListener(FarmEvent.FRIENDLIST_UPDATESTOLEN,this.__updateFriendListStolen);
         this._switchAsset.addEventListener(MouseEvent.CLICK,this.__onClick);
         this._switchAsset.addEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
         this._switchAsset.addEventListener(MouseEvent.MOUSE_OUT,this.__outHandler);
         PlayerManager.Instance.friendList.addEventListener(DictionaryEvent.REMOVE,this.__playerRemove);
      }
      
      protected function __playerRemove(param1:DictionaryEvent) : void
      {
         var _loc2_:FriendListPlayer = param1.data as FriendListPlayer;
         FarmModelController.instance.model.friendStateList.remove(_loc2_.ID);
         this.update();
      }
      
      protected function __outHandler(param1:MouseEvent) : void
      {
         this._switchAsset.filters = null;
      }
      
      protected function __overHandler(param1:MouseEvent) : void
      {
         this._switchAsset.filters = ComponentFactory.Instance.creatFilters("lightFilter");
      }
      
      protected function __friendlistHandler(param1:Event) : void
      {
         this.update();
      }
      
      protected function __infoReady(param1:FarmEvent) : void
      {
         this.update();
      }
      
      protected function __updateFriendListStolen(param1:FarmEvent) : void
      {
         var _loc3_:FarmFriendListItem = null;
         var _loc4_:FramFriendStateInfo = null;
         var _loc2_:FramFriendStateInfo = FarmModelController.instance.model.friendStateListStolenInfo[FarmModelController.instance.model.currentFarmerId];
         for each(_loc3_ in this._list.list.cell)
         {
            if(_loc3_.info)
            {
               if(_loc3_.info.id == _loc2_.id)
               {
                  _loc3_.setCellValue(_loc2_);
                  break;
               }
            }
         }
         for each(_loc4_ in (this._list.list.model as VectorListModel).elements)
         {
            if(_loc4_.id == _loc2_.id)
            {
               _loc4_.landStateVec = _loc2_.landStateVec;
               break;
            }
         }
      }
      
      private function __onClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.switchView();
         if(PetBagController.instance().haveTaskOrderByID(PetFarmGuildeTaskType.PET_TASK6))
         {
            PetBagController.instance().clearCurrentPetFarmGuildeArrow(ArrowType.OPEN_IM);
         }
      }
      
      private function switchView() : void
      {
         var _loc1_:int = !!this.isOpen ? int(int(2)) : int(int(1));
         this._switchAsset.setFrame(_loc1_);
         if(this.isOpen)
         {
            this._switchTween = null;
            this._switchTween = TweenLite.to(this,0.5,{
               "x":952,
               "ease":Sine.easeInOut
            });
         }
         else
         {
            FarmModelController.instance.updateSetupFriendListLoader();
            this._switchTween = null;
            this._switchTween = TweenLite.to(this,0.5,{
               "x":773,
               "ease":Sine.easeInOut
            });
         }
         this.isOpen = _loc1_ == 1 ? Boolean(Boolean(true)) : Boolean(Boolean(false));
      }
      
      private function update() : void
      {
         var _loc1_:FramFriendStateInfo = null;
         var _loc2_:PlayerInfo = null;
         this._list.vectorListModel.clear();
         for each(_loc1_ in FarmModelController.instance.model.friendStateList)
         {
            _loc2_ = _loc1_.playerinfo;
            if(_loc2_)
            {
               this._list.vectorListModel.insertElementAt(_loc1_,this.getInsertIndex(_loc2_));
            }
         }
         this._list.list.updateListView();
      }
      
      private function getInsertIndex(param1:PlayerInfo) : int
      {
         var _loc4_:PlayerInfo = null;
         var _loc2_:int = 0;
         var _loc3_:Array = this._list.vectorListModel.elements;
         if(_loc3_.length == 0)
         {
            return 0;
         }
         for(var _loc5_:int = _loc3_.length - 1; _loc5_ >= 0; )
         {
            _loc4_ = (_loc3_[_loc5_] as FramFriendStateInfo).playerinfo;
            if(!(param1.IsVIP && !_loc4_.IsVIP))
            {
               if(!param1.IsVIP && _loc4_.IsVIP)
               {
                  return _loc5_ + 1;
               }
               if(param1.IsVIP == _loc4_.IsVIP)
               {
                  if(param1.Grade <= _loc4_.Grade)
                  {
                     return _loc5_ + 1;
                  }
                  _loc2_ = _loc5_ - 1;
               }
            }
            _loc5_--;
         }
         return _loc2_ < 0 ? int(int(0)) : int(int(_loc2_));
      }
      
      private function removeEvent() : void
      {
         PlayerManager.Instance.removeEventListener(PlayerManager.FRIENDLIST_COMPLETE,this.__friendlistHandler);
         FarmModelController.instance.removeEventListener(FarmEvent.FRIEND_INFO_READY,this.__infoReady);
         FarmModelController.instance.removeEventListener(FarmEvent.FRIENDLIST_UPDATESTOLEN,this.__updateFriendListStolen);
         this._switchAsset.removeEventListener(MouseEvent.CLICK,this.__onClick);
         this._switchAsset.removeEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
         this._switchAsset.removeEventListener(MouseEvent.MOUSE_OUT,this.__outHandler);
         PlayerManager.Instance.friendList.removeEventListener(DictionaryEvent.REMOVE,this.__playerRemove);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(this._switchTween)
         {
            this._switchTween.kill();
         }
         this._switchTween = null;
         if(this._list)
         {
            ObjectUtils.disposeObject(this._list);
         }
         this._list = null;
         if(this._switchAsset)
         {
            ObjectUtils.disposeObject(this._switchAsset);
         }
         this._switchAsset = null;
         if(this._listBG)
         {
            ObjectUtils.disposeObject(this._listBG);
         }
         this._listBG = null;
         if(this._listBound)
         {
            ObjectUtils.disposeObject(this._listBound);
         }
         this._listBound = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
