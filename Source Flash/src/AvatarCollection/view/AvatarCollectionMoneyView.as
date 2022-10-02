package AvatarCollection.view
{
   import bagAndInfo.bag.RichesButton;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.utils.PositionUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class AvatarCollectionMoneyView extends Sprite implements Disposeable
   {
       
      
      private var _honorBg:MovieClip;
      
      private var _honorTxt:FilterFrameText;
      
      private var _goldBg:MovieClip;
      
      private var _goldTxt:FilterFrameText;
      
      private var _honorButton:RichesButton;
      
      private var _goldButton:RichesButton;
      
      public function AvatarCollectionMoneyView()
      {
         super();
         this.x = 19;
         this.y = 388;
         this.initView();
         this.initEvent();
         this.refreshView();
      }
      
      private function initView() : void
      {
         this._honorBg = ComponentFactory.Instance.creat("asset.avatarColl.honorIcon");
         this._honorTxt = ComponentFactory.Instance.creatComponentByStylename("avatarColl.rightView.honorTxt");
         this._goldBg = ComponentFactory.Instance.creat("asset.avatarColl.goldIcon");
         PositionUtils.setPos(this._goldBg,"avatarColl.rightView.goldBgPos");
         this._goldTxt = ComponentFactory.Instance.creatComponentByStylename("avatarColl.rightView.goldTxt");
         this._honorButton = ComponentFactory.Instance.creatCustomObject("avatarColl.rightMoneyView.honorButton");
         this._honorButton.tipData = LanguageMgr.GetTranslation("ddt.totem.rightView.honorTipTxt");
         this._goldButton = ComponentFactory.Instance.creatCustomObject("avatarColl.rightMoneyView.goldButton");
         this._goldButton.tipData = LanguageMgr.GetTranslation("tank.view.bagII.MoneyDirections");
         addChild(this._honorBg);
         addChild(this._honorTxt);
         addChild(this._goldBg);
         addChild(this._goldTxt);
         addChild(this._honorButton);
         addChild(this._goldButton);
      }
      
      private function initEvent() : void
      {
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
      }
      
      private function __propertyChange(param1:PlayerPropertyEvent) : void
      {
         if(param1.changedProperties[PlayerInfo.GOLD] || param1.changedProperties["myHonor"])
         {
            this.refreshView();
         }
      }
      
      private function refreshView() : void
      {
         //this._honorTxt.text = "0";//PlayerManager.Instance.Self.myHonor.toString();
		 this._honorTxt.text = PlayerManager.Instance.Self.myHonor.toString();
         this._goldTxt.text = PlayerManager.Instance.Self.Gold.toString();
      }
      
      private function removeEvent() : void
      {
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._honorBg = null;
         this._honorTxt = null;
         this._goldBg = null;
         this._goldTxt = null;
         this._honorButton = null;
         this._goldButton = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
