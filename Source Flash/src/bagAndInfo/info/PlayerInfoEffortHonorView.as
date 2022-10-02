package bagAndInfo.info
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ComboBox;
   import com.pickgliss.ui.core.Disposeable;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.EffortManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import newTitle.NewTitleControl;
   import newTitle.NewTitleManager;
   import newTitle.event.NewTitleEvent;
   
   public class PlayerInfoEffortHonorView extends Sprite implements Disposeable
   {
       
      
      private var _nameChoose:ComboBox;
      
      private var _honorArray:Array;
      
      public function PlayerInfoEffortHonorView()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._nameChoose = ComponentFactory.Instance.creatComponentByStylename("personInfoViewNameChoose");
         addChild(this._nameChoose);
         this._nameChoose.button.addEventListener(MouseEvent.CLICK,this.__buttonClick);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
         NewTitleManager.instance.addEventListener("selectTitle",this.__onSelectTitle);
         this.setlist(EffortManager.Instance.getHonorArray());
         this.update();
      }
      
      private function __propertyChange(param1:PlayerPropertyEvent) : void
      {
         if(param1.changedProperties["honor"] == true)
         {
            if(PlayerManager.Instance.Self.honor != "")
            {
               this._nameChoose.textField.text = PlayerManager.Instance.Self.honor;
               NewTitleManager.instance.dispatchEvent(new NewTitleEvent("setSelectTitle"));
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("newTitleView.useTitleSuccessTxt",this._nameChoose.textField.text));
            }
            else
            {
               this._nameChoose.textField.text = LanguageMgr.GetTranslation("bagAndInfo.info.PlayerInfoEffortHonorView.selecting");
            }
         }
      }
      
      private function __buttonClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         NewTitleControl.instance.show();
      }
      
      private function update() : void
      {
         if(PlayerManager.Instance.Self.honor != "")
         {
            this._nameChoose.textField.text = PlayerManager.Instance.Self.honor;
         }
         else
         {
            this._nameChoose.textField.text = LanguageMgr.GetTranslation("bagAndInfo.info.PlayerInfoEffortHonorView.selecting");
         }
      }
      
      private function __onSelectTitle(event:NewTitleEvent) : void
      {
         var _loc2_:String = event.data[0];
         if(_loc2_)
         {
            SocketManager.Instance.out.sendReworkRank(_loc2_);
         }
         else
         {
            SocketManager.Instance.out.sendReworkRank("");
            this._nameChoose.textField.text = LanguageMgr.GetTranslation("bagAndInfo.info.PlayerInfoEffortHonorView.selecting");
         }
      }
      
      public function setlist(param1:Array) : void
      {
         this._honorArray = [];
         this._honorArray = param1;
         if(!this._honorArray)
         {
            return;
         }
      }
      
      public function dispose() : void
      {
         NewTitleManager.instance.removeEventListener("selectTitle",this.__onSelectTitle);
         this._nameChoose.button.removeEventListener(MouseEvent.CLICK,this.__buttonClick);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
         this._nameChoose.dispose();
         this._nameChoose = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
