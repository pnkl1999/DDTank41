package AvatarCollection.view
{
   import AvatarCollection.data.AvatarCollectionItemVo;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.BaseTip;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   
   public class AvatarCollectionItemTip extends BaseTip
   {
       
      
      private var _bg:ScaleBitmapImage;
      
      private var _line:ScaleBitmapImage;
      
      private var _titleTxt:FilterFrameText;
      
      private var _typeNameTxt:FilterFrameText;
      
      private var _typeValueTxt:FilterFrameText;
      
      private var _activityStatusTxt:FilterFrameText;
      
      private var _needMoneyTxt:FilterFrameText;
      
      private var _placeTxt:FilterFrameText;
      
      private var _notActivityTxt:FilterFrameText;
      
      private var _tempData:AvatarCollectionItemVo;
      
      private var _activityTxtList:Array;
      
      private var _placeTxtList:Array;
      
      public function AvatarCollectionItemTip()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this._activityTxtList = LanguageMgr.GetTranslation("avatarCollection.itemTip.activityTxt").split(",");
         this._placeTxtList = LanguageMgr.GetTranslation("avatarCollection.itemTip.placeValueStrTxt").split(",");
         this._bg = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipBg");
         this._bg.width = 195;
         addChild(this._bg);
         this._line = ComponentFactory.Instance.creatComponentByStylename("HRuleAsset");
         this._line.width = 110;
         this._line.x = 42;
         this._line.y = 51;
         addChild(this._line);
         this._titleTxt = ComponentFactory.Instance.creatComponentByStylename("avatarColl.propertyTip.titleTxt");
         this._typeNameTxt = ComponentFactory.Instance.creatComponentByStylename("avatarColl.itemTip.typeNameTxt");
         this._typeNameTxt.text = LanguageMgr.GetTranslation("avatarCollection.itemTip.typeNameTxt");
         this._typeValueTxt = ComponentFactory.Instance.creatComponentByStylename("avatarColl.itemTip.typeValueTxt");
         this._activityStatusTxt = ComponentFactory.Instance.creatComponentByStylename("avatarColl.propertyTip.nameTxt");
         PositionUtils.setPos(this._activityStatusTxt,"avatarColl.itemTip.activityStatusTxtPos");
         this._needMoneyTxt = ComponentFactory.Instance.creatComponentByStylename("avatarColl.propertyTip.nameTxt");
         this._placeTxt = ComponentFactory.Instance.creatComponentByStylename("avatarColl.propertyTip.nameTxt");
         this._notActivityTxt = ComponentFactory.Instance.creatComponentByStylename("avatarColl.itemCellTip.notActivityTxt");
         this._notActivityTxt.text = this._activityTxtList[1];
         this._notActivityTxt.visible = false;
         addChild(this._titleTxt);
         addChild(this._typeNameTxt);
         addChild(this._typeValueTxt);
         addChild(this._activityStatusTxt);
         addChild(this._needMoneyTxt);
         addChild(this._placeTxt);
         addChild(this._notActivityTxt);
      }
      
      override public function get tipData() : Object
      {
         return this._tempData;
      }
      
      override public function set tipData(param1:Object) : void
      {
         this._tempData = param1 as AvatarCollectionItemVo;
         if(!this._tempData)
         {
            return;
         }
         var _loc2_:ItemTemplateInfo = this._tempData.itemInfo;
         this._titleTxt.text = _loc2_.Name;
         this._typeValueTxt.text = LanguageMgr.GetTranslation("avatarCollection.itemTip.typeValueTxt",EquipType.PARTNAME[_loc2_.CategoryID]);
         this._placeTxt.text = LanguageMgr.GetTranslation("avatarCollection.itemTip.placeTxt") + this._placeTxtList[int(this._tempData.proArea) - 1];
         if(this._tempData.isActivity)
         {
            this._activityStatusTxt.text = LanguageMgr.GetTranslation("avatarCollection.itemTip.activityStatusTxt") + this._activityTxtList[0];
            this._notActivityTxt.visible = false;
            this._needMoneyTxt.visible = false;
            PositionUtils.setPos(this._placeTxt,"avatarColl.itemTip.needGoldTxtPos");
         }
         else
         {
            this._activityStatusTxt.text = LanguageMgr.GetTranslation("avatarCollection.itemTip.activityStatusTxt");
            this._notActivityTxt.visible = true;
            this._needMoneyTxt.visible = true;
            this._needMoneyTxt.text = LanguageMgr.GetTranslation("avatarCollection.itemTip.needGoldTxt",this._tempData.needGold);
            PositionUtils.setPos(this._needMoneyTxt,"avatarColl.itemTip.needGoldTxtPos");
            PositionUtils.setPos(this._placeTxt,"avatarColl.itemTip.placeTxtPos");
         }
         this._bg.height = this._placeTxt.y + 32;
      }
      
      override public function get width() : Number
      {
         return this._bg.width;
      }
      
      override public function get height() : Number
      {
         return this._bg.height;
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._line = null;
         this._titleTxt = null;
         this._typeNameTxt = null;
         this._typeValueTxt = null;
         this._activityStatusTxt = null;
         this._needMoneyTxt = null;
         this._placeTxt = null;
         this._notActivityTxt = null;
         this._tempData = null;
         this._activityTxtList = null;
         super.dispose();
      }
   }
}
