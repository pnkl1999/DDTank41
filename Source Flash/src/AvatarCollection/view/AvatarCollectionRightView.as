package AvatarCollection.view
{
   import AvatarCollection.data.AvatarCollectionUnitVo;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Sprite;
   
   public class AvatarCollectionRightView extends Sprite implements Disposeable
   {
       
      
      private var _data:AvatarCollectionUnitVo;
      
      private var _itemListView:AvatarCollectionItemListView;
      
      private var _propertyView:AvatarCollectionPropertyView;
      
      private var _descTxt:FilterFrameText;
      
      private var _moneyView:AvatarCollectionMoneyView;
      
      private var _timeView:AvatarCollectionTimeView;
      
      public function AvatarCollectionRightView()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._itemListView = new AvatarCollectionItemListView();
         addChild(this._itemListView);
         this._descTxt = ComponentFactory.Instance.creatComponentByStylename("avatarColl.rightView.descTxt");
         this._descTxt.text = LanguageMgr.GetTranslation("avatarCollection.rightView.descTxt");
         addChild(this._descTxt);
         this._moneyView = new AvatarCollectionMoneyView();
         addChild(this._moneyView);
         this._timeView = new AvatarCollectionTimeView();
         addChild(this._timeView);
         this._propertyView = new AvatarCollectionPropertyView();
         addChild(this._propertyView);
      }
      
      public function refreshView(param1:AvatarCollectionUnitVo) : void
      {
         this._itemListView.refreshView(Boolean(param1)?param1.totalItemList:null);
         this._propertyView.refreshView(param1);
         this._timeView.refreshView(param1);
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._data = null;
         this._itemListView = null;
         this._propertyView = null;
         this._descTxt = null;
         this._moneyView = null;
         this._timeView = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
