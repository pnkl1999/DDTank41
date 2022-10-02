package shop.view
{
   import bagAndInfo.cell.CellFactory;
   import baglocked.BagLockedController;
   import com.pickgliss.effect.EffectColorType;
   import com.pickgliss.effect.EffectManager;
   import com.pickgliss.effect.EffectTypes;
   import com.pickgliss.effect.IEffect;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.SelectedIconButton;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.utils.PositionUtils;
   import ddt.view.ColorEditor;
   import ddt.view.character.RoomCharacter;
   import flash.display.Bitmap;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   
   public class ShopLeftViewPropCollection
   {
      
      public static const PLAYER_MAX_EQUIP_CNT:uint = 8;
       
      
      public var bg:Scale9CornerImage;
      
      public var btnClearEquip:BaseButton;
      
      public var btnClearLastEquip:BaseButton;
      
      public var btnOriginEquip:BaseButton;
      
      public var cartBtn:SelectedButton;
      
      public var cartList:VBox;
      
      public var cartScroll:ScrollPanel;
      
      public var hiddenControlsBg:Bitmap;
      
      public var cbHideGlasses:SelectedCheckButton;
      
      public var cbHideHat:SelectedCheckButton;
      
      public var cbHideSuit:SelectedCheckButton;
      
      public var cbHideWings:SelectedCheckButton;
      
      public var colorEditor:ColorEditor;
      
      public var costGiftTxt:FilterFrameText;
      
      public var costMedalTxt:FilterFrameText;
      
      public var costMoneyTxt:FilterFrameText;
      
      public var currentCountTxt:FilterFrameText;
      
      public var dressBtn:SelectedButton;
      
      public var dressView:Sprite;
      
      public var femaleCharacter:RoomCharacter;
      
      public var infoBg:Bitmap;
      
      public var fittingRoomText:Bitmap;
      
      public var lastItem:ShopPlayerCell;
      
      public var maleCharacter:RoomCharacter;
      
      public var middlePanelBg:ScaleFrameImage;
      
      public var leftMoneyPanelBuyBtn:BaseButton;
      
      public var muteLock:Boolean;
      
      public var panelBtnGroup:SelectedButtonGroup;
      
      public var panelCartBtn:SelectedIconButton;
      
      public var panelColorBtn:SelectedIconButton;
      
      public var playerCells:Vector.<ShopPlayerCell>;
      
      public var playerGiftTxt:FilterFrameText;
      
      public var playerMedalTxt:FilterFrameText;
      
      public var playerMoneyTxt:FilterFrameText;
      
      public var playerNameTxt:FilterFrameText;
      
      public var playerRank:Bitmap;
      
      public var playerRankTxt:FilterFrameText;
      
      public var presentBtn:BaseButton;
      
      public var purchaseBtn:BaseButton;
      
      public var checkOutPanel:ShopCheckOutView;
      
      public var saveFigureBtn:BaseButton;
      
      public var topBtnGroup:SelectedButtonGroup;
      
      public var addedManNewEquip:int = 0;
      
      public var addedWomanNewEquip:int = 0;
      
      public var purchaseView:Sprite;
      
      public var adjustColorView:Sprite;
      
      public var presentEffet:IEffect;
      
      public var purchaseEffet:IEffect;
      
      public var saveFigureEffet:IEffect;
      
      public var colorEffet:IEffect;
      
      public var canShine:Boolean;
      
      public var bagLockedController:BagLockedController;
      
      public var randomBtn:BaseButton;
      
      public function ShopLeftViewPropCollection()
      {
         super();
      }
      
      public function setup() : void
      {
         var _loc2_:ShopPlayerCell = null;
         this.topBtnGroup = new SelectedButtonGroup();
         this.panelBtnGroup = new SelectedButtonGroup();
         this.playerCells = new Vector.<ShopPlayerCell>();
         this.dressView = new Sprite();
         this.dressView.x = 1;
         this.dressView.y = -1;
         this.purchaseView = new Sprite();
         this.adjustColorView = new Sprite();
         this.lastItem = CellFactory.instance.createShopColorItemCell() as ShopPlayerCell;
         this.bg = ComponentFactory.Instance.creatComponentByStylename("shop.LeftViewBg");
         this.infoBg = ComponentFactory.Instance.creatBitmap("asset.shop.BodyInfoBg");
         this.middlePanelBg = ComponentFactory.Instance.creatComponentByStylename("shop.LeftMiddlePanelBg");
         this.leftMoneyPanelBuyBtn = ComponentFactory.Instance.creatComponentByStylename("shop.LeftMoneyPanelBuyBtn");
         this.dressBtn = ComponentFactory.Instance.creatComponentByStylename("shop.DressBtn");
         this.cartBtn = ComponentFactory.Instance.creatComponentByStylename("shop.CartBtn");
         this.saveFigureBtn = ComponentFactory.Instance.creatComponentByStylename("shop.BtnSaveFigure");
         this.presentBtn = ComponentFactory.Instance.creatComponentByStylename("shop.BtnPresent");
         this.purchaseBtn = ComponentFactory.Instance.creatComponentByStylename("shop.BtnPurchase");
         this.panelCartBtn = ComponentFactory.Instance.creatComponentByStylename("shop.BtnShopCart");
         this.panelColorBtn = ComponentFactory.Instance.creatComponentByStylename("shop.BtnColorPanel");
         this.btnClearEquip = ComponentFactory.Instance.creatComponentByStylename("shop.BtnClearEquip");
         this.btnClearLastEquip = ComponentFactory.Instance.creatComponentByStylename("shop.BtnClearLastEquip");
         this.btnOriginEquip = ComponentFactory.Instance.creatComponentByStylename("shop.BtnOriginEquip");
         this.playerRank = ComponentFactory.Instance.creatBitmap("asset.shop.PlayerRank");
         this.playerNameTxt = ComponentFactory.Instance.creatComponentByStylename("shop.PlayerName");
         this.playerRankTxt = ComponentFactory.Instance.creatComponentByStylename("shop.PlayerRank");
         this.costMoneyTxt = ComponentFactory.Instance.creatComponentByStylename("shop.CostMoney");
         this.costGiftTxt = ComponentFactory.Instance.creatComponentByStylename("shop.CostGift");
         this.costMedalTxt = ComponentFactory.Instance.creatComponentByStylename("shop.CostMedal");
         this.playerMoneyTxt = ComponentFactory.Instance.creatComponentByStylename("shop.PlayerMoney");
         PositionUtils.setPos(this.playerMoneyTxt,"shop.playerMoneyTxtPos");
         this.playerGiftTxt = ComponentFactory.Instance.creatComponentByStylename("shop.PlayerGift");
         PositionUtils.setPos(this.playerGiftTxt,"shop.playerGiftTxtPos");
         this.playerMedalTxt = ComponentFactory.Instance.creatComponentByStylename("shop.PlayerMedal");
         PositionUtils.setPos(this.playerMedalTxt,"shop.playerMedalTxtPos");
         this.currentCountTxt = ComponentFactory.Instance.creatComponentByStylename("shop.CurrentCount");
         this.cartScroll = ComponentFactory.Instance.creatComponentByStylename("shop.CartItemList");
         this.cartList = ComponentFactory.Instance.creatComponentByStylename("shop.CartItemContainer");
         this.hiddenControlsBg = ComponentFactory.Instance.creatBitmap("asset.shop.HiddenControlsBg");
         PositionUtils.setPos(this.hiddenControlsBg,"shop.hiddenControlsBgPos");
         this.cbHideGlasses = ComponentFactory.Instance.creatComponentByStylename("shop.HideGlassesCb");
         this.cbHideHat = ComponentFactory.Instance.creatComponentByStylename("shop.HideHatCb");
         this.cbHideSuit = ComponentFactory.Instance.creatComponentByStylename("shop.HideSuitCb");
         this.cbHideWings = ComponentFactory.Instance.creatComponentByStylename("shop.HideWingsCb");
         this.cbHideGlasses.text = LanguageMgr.GetTranslation("tank.view.changeColor.ChangeColorLeftView.glass");
         this.cbHideHat.text = LanguageMgr.GetTranslation("shop.ShopIITryDressView.hideHat");
         this.cbHideSuit.text = LanguageMgr.GetTranslation("tank.view.changeColor.ChangeColorLeftView.suit");
         this.cbHideWings.text = LanguageMgr.GetTranslation("tank.view.changeColor.ChangeColorLeftView.Wings");
         this.colorEditor = ComponentFactory.Instance.creatCustomObject("shop.ColorEdit");
         this.checkOutPanel = ComponentFactory.Instance.creatCustomObject("shop.CheckOutView");
         this.presentEffet = EffectManager.Instance.creatEffect(EffectTypes.ALPHA_SHINER_ANIMATION,this.presentBtn);
         this.purchaseEffet = EffectManager.Instance.creatEffect(EffectTypes.ALPHA_SHINER_ANIMATION,this.purchaseBtn,{"color":EffectColorType.GOLD});
         this.saveFigureEffet = EffectManager.Instance.creatEffect(EffectTypes.SHINER_ANIMATION,this.saveFigureBtn);
         this.colorEffet = EffectManager.Instance.creatEffect(EffectTypes.ADD_MOVIE_EFFECT,this.panelColorBtn,"asset.shop.ColorBtnEffect");
         this.bagLockedController = new BagLockedController();
         this.btnClearEquip.tipData = LanguageMgr.GetTranslation("shop.ShopIITryDressView.returnToBegin1");
         this.btnClearLastEquip.tipData = LanguageMgr.GetTranslation("shop.ShopIITryDressView.repeal");
         this.btnOriginEquip.tipData = LanguageMgr.GetTranslation("shop.view.restore");
         this.muteLock = false;
         this.middlePanelBg.setFrame(1);
         this.cartScroll.vScrollProxy = ScrollPanel.ON;
         this.cartScroll.setView(this.cartList);
         this.cartScroll.invalidateViewport(true);
         this.cartScroll.vUnitIncrement = 15;
         this.cartScroll.visible = false;
         this.cartList.strictSize = 66;
         this.cartList.isReverAdd = true;
         this.topBtnGroup.addSelectItem(this.dressBtn);
         this.topBtnGroup.addSelectItem(this.cartBtn);
         this.topBtnGroup.selectIndex = 0;
         this.dressBtn.visible = this.cartBtn.visible = false;
         this.panelBtnGroup.addSelectItem(this.panelCartBtn);
         this.panelBtnGroup.addSelectItem(this.panelColorBtn);
         this.panelCartBtn.displacement = this.panelColorBtn.displacement = false;
         this.panelBtnGroup.selectIndex = 0;
         this.saveFigureBtn.enable = false;
         this.presentBtn.enable = false;
         this.purchaseBtn.enable = false;
         this.panelColorBtn.enable = false;
         this.leftMoneyPanelBuyBtn.enable = false;
         this.playerNameTxt.text = PlayerManager.Instance.Self.NickName;
         this.playerRankTxt.text = String(PlayerManager.Instance.Self.Repute);
         this.costMoneyTxt.text = "0";
         this.costGiftTxt.text = "0";
         this.costMedalTxt.text = "0";
         this.playerMoneyTxt.text = String(PlayerManager.Instance.Self.Money);
         this.playerGiftTxt.text = String(PlayerManager.Instance.Self.Gift);
         this.playerMedalTxt.text = String(PlayerManager.Instance.Self.medal);
         this.currentCountTxt.text = "0";
         this.currentCountTxt.mouseEnabled = false;
         this.colorEditor.visible = false;
         this.colorEditor.restorable = false;
         this.lastItem.visible = false;
         PositionUtils.setPos(this.lastItem,"shop.LastItemPos");
         this.canShine = true;
         this.dressView.addChild(this.infoBg);
         this.dressView.addChild(this.saveFigureBtn);
         this.dressView.addChild(this.btnClearLastEquip);
         this.dressView.addChild(this.playerRank);
         this.dressView.addChild(this.playerNameTxt);
         this.dressView.addChild(this.playerRankTxt);
         this.dressView.addChild(this.hiddenControlsBg);
         this.dressView.addChild(this.cbHideGlasses);
         this.dressView.addChild(this.cbHideHat);
         this.dressView.addChild(this.cbHideSuit);
         this.dressView.addChild(this.cbHideWings);
         this.purchaseView.addChild(this.playerMoneyTxt);
         this.purchaseView.addChild(this.playerGiftTxt);
         this.purchaseView.addChild(this.playerMedalTxt);
         this.purchaseView.addChild(this.leftMoneyPanelBuyBtn);
         var _loc1_:int = 0;
         while(_loc1_ < PLAYER_MAX_EQUIP_CNT)
         {
            _loc2_ = CellFactory.instance.createShopPlayerItemCell() as ShopPlayerCell;
            PositionUtils.setPos(_loc2_,"shop.PlayerCellPos_" + String(_loc1_));
            this.playerCells.push(_loc2_);
            this.dressView.addChild(_loc2_);
            _loc1_++;
         }
         this.randomBtn = ComponentFactory.Instance.creatComponentByStylename("shop.randomBtn");
      }
      
      public function addChildrenTo(param1:DisplayObjectContainer) : void
      {
         param1.addChild(this.bg);
         param1.addChild(this.middlePanelBg);
         param1.addChild(this.dressBtn);
         param1.addChild(this.cartBtn);
         param1.addChild(this.purchaseBtn);
         param1.addChild(this.panelCartBtn);
         param1.addChild(this.panelColorBtn);
         param1.addChild(this.dressView);
         param1.addChild(this.colorEditor);
         param1.addChild(this.purchaseView);
         param1.addChild(this.cartScroll);
         param1.addChild(this.lastItem);
         param1.addChild(this.randomBtn);
      }
      
      public function disposeAllChildrenFrom(param1:DisplayObjectContainer) : void
      {
         EffectManager.Instance.removeEffect(this.presentEffet);
         EffectManager.Instance.removeEffect(this.purchaseEffet);
         EffectManager.Instance.removeEffect(this.saveFigureEffet);
         EffectManager.Instance.removeEffect(this.colorEffet);
         ObjectUtils.disposeAllChildren(this.colorEditor);
         ObjectUtils.disposeAllChildren(this.dressView);
         ObjectUtils.disposeAllChildren(this.purchaseView);
         ObjectUtils.disposeAllChildren(param1);
         this.topBtnGroup.dispose();
         this.topBtnGroup = null;
         this.panelBtnGroup.dispose();
         this.panelBtnGroup = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.playerCells.length)
         {
            this.playerCells[_loc2_] = null;
            _loc2_++;
         }
         this.dressView = null;
         this.purchaseView = null;
         param1 = null;
         this.playerCells = null;
         this.dressView = null;
         this.lastItem = null;
         this.bg = null;
         this.infoBg = null;
         this.middlePanelBg = null;
         this.leftMoneyPanelBuyBtn = null;
         this.dressBtn = null;
         this.cartBtn = null;
         this.saveFigureBtn = null;
         this.presentBtn = null;
         this.purchaseBtn = null;
         this.panelCartBtn = null;
         this.panelColorBtn = null;
         this.btnClearEquip = null;
         this.btnClearLastEquip = null;
         this.btnOriginEquip = null;
         this.playerRank = null;
         this.playerNameTxt = null;
         this.playerRankTxt = null;
         this.costMoneyTxt = null;
         this.costGiftTxt = null;
         this.costMedalTxt = null;
         this.playerMoneyTxt = null;
         this.playerGiftTxt = null;
         this.playerMedalTxt = null;
         this.currentCountTxt = null;
         this.cartScroll = null;
         this.cartList = null;
         this.hiddenControlsBg = null;
         this.cbHideGlasses = null;
         this.cbHideHat = null;
         this.cbHideSuit = null;
         this.colorEditor = null;
         this.randomBtn = null;
         this.bagLockedController.close();
         this.bagLockedController = null;
      }
   }
}
