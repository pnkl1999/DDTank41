package totem.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import totem.TotemManager;
   
   public class TotemActivateProtectView extends Sprite implements Disposeable
   {
       
      
      private var _activateProtectSCB:SelectedCheckButton;
      
      public function TotemActivateProtectView()
      {
         super();
         this._activateProtectSCB = ComponentFactory.Instance.creatComponentByStylename("totem.activateProtectSCB");
         this._activateProtectSCB.selected = TotemManager.instance.isSelectedActPro;
         this._activateProtectSCB.tipData = LanguageMgr.GetTranslation("ddt.totem.activateProtectTipTxt");
         this._activateProtectSCB.addEventListener(MouseEvent.CLICK,this.clickHandler,false,0,true);
         addChild(this._activateProtectSCB);
         this._activateProtectSCB.visible = false;
      }
      
      private function clickHandler(param1:MouseEvent) : void
      {
         TotemManager.instance.isSelectedActPro = this._activateProtectSCB.selected;
         TotemManager.instance.isDonotPromptActPro = false;
         TotemManager.instance.isBindInNoPrompt = false;
      }
      
      public function dispose() : void
      {
         if(this._activateProtectSCB)
         {
            this._activateProtectSCB.removeEventListener(MouseEvent.CLICK,this.clickHandler);
         }
         ObjectUtils.disposeObject(this._activateProtectSCB);
         this._activateProtectSCB = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
