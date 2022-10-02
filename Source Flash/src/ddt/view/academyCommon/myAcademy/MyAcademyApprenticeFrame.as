package ddt.view.academyCommon.myAcademy
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.core.Disposeable;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.AcademyManager;
   import ddt.utils.PositionUtils;
   import ddt.view.academyCommon.myAcademy.myAcademyItem.MyAcademyClassmateItem;
   import ddt.view.academyCommon.myAcademy.myAcademyItem.MyAcademyMasterItem;
   import flash.events.MouseEvent;
   import road7th.data.DictionaryEvent;
   
   public class MyAcademyApprenticeFrame extends MyAcademyMasterFrame implements Disposeable
   {
       
      
      private var _masterItem:MyAcademyMasterItem;
      
      private var _classmateItem:MyAcademyClassmateItem;
      
      private var _classmateItemII:MyAcademyClassmateItem;
      
      private var _masterInfo:PlayerInfo;
      
      private var _ApprenticeInfos:Vector.<PlayerInfo>;
      
      public function MyAcademyApprenticeFrame()
      {
         super();
      }
      
      override public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      override protected function initItem() : void
      {
         _myAcademyIcon = ComponentFactory.Instance.creatBitmap("asset.academyCommon.myAcademy.myAcademyMasterIcon");
         addToContent(_myAcademyIcon);
         _itemBG = ComponentFactory.Instance.creatComponentByStylename("asset.academyCommon.myAcademy.myAcademyMasterBG");
         addToContent(_itemBG);
         this._masterItem = new MyAcademyMasterItem();
         PositionUtils.setPos(this._masterItem,"academyCommon.myAcademy.MyAcademyApprenticeFrame.masterItem");
         addToContent(this._masterItem);
         this._classmateItem = new MyAcademyClassmateItem();
         PositionUtils.setPos(this._classmateItem,"academyCommon.myAcademy.MyAcademyApprenticeFrame.classmateItem");
         addToContent(this._classmateItem);
         this._classmateItemII = new MyAcademyClassmateItem();
         PositionUtils.setPos(this._classmateItemII,"academyCommon.myAcademy.MyAcademyApprenticeFrame.classmateItemII");
         addToContent(this._classmateItemII);
         _masterHonorBG.visible = false;
         this._ApprenticeInfos = new Vector.<PlayerInfo>();
         this.updateItem();
      }
      
      override protected function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,__onResponse);
         this._masterItem.addEventListener(MouseEvent.CLICK,__itemClick);
         _titleBtn.addEventListener(MouseEvent.CLICK,__titleBtnClick);
         this._classmateItem.addEventListener(MouseEvent.CLICK,__itemClick);
         this._classmateItemII.addEventListener(MouseEvent.CLICK,__itemClick);
         AcademyManager.Instance.myAcademyPlayers.addEventListener(DictionaryEvent.REMOVE,__removeItem);
         AcademyManager.Instance.myAcademyPlayers.addEventListener(DictionaryEvent.CLEAR,__clearItem);
      }
      
      override protected function updateItem() : void
      {
         this.sliceInfo();
         switch(_myApprentice.length)
         {
            case 0:
               this._masterItem.visible = false;
               this._classmateItem.visible = false;
               this._classmateItemII.visible = false;
               break;
            case 1:
               this._masterItem.info = this._masterInfo;
               this._classmateItem.visible = false;
               this._classmateItemII.visible = false;
               break;
            case 2:
               this._masterItem.info = this._masterInfo;
               this._classmateItem.info = this._ApprenticeInfos[0];
               this._classmateItemII.visible = false;
               break;
            case 3:
               this._masterItem.info = this._masterInfo;
               this._classmateItem.info = this._ApprenticeInfos[0];
               this._classmateItemII.info = this._ApprenticeInfos[1];
         }
      }
      
      private function sliceInfo() : void
      {
         var _loc1_:PlayerInfo = null;
         for each(_loc1_ in _myApprentice)
         {
            if(_loc1_.apprenticeshipState == AcademyManager.APPRENTICE_STATE)
            {
               this._ApprenticeInfos.push(_loc1_);
            }
            else
            {
               this._masterInfo = _loc1_;
            }
         }
      }
      
      override protected function clearItem() : void
      {
         if(this._masterItem)
         {
            this._masterItem.removeEventListener(MouseEvent.CLICK,__itemClick);
            this._masterItem.dispose();
            this._masterItem = null;
         }
         if(this._classmateItem)
         {
            this._classmateItem.removeEventListener(MouseEvent.CLICK,__itemClick);
            this._classmateItem.dispose();
            this._classmateItem = null;
         }
         if(this._classmateItemII)
         {
            this._classmateItemII.removeEventListener(MouseEvent.CLICK,__itemClick);
            this._classmateItemII.dispose();
            this._classmateItemII = null;
         }
      }
   }
}
