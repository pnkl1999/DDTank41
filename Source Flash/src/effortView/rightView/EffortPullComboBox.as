package effortView.rightView
{
   import com.pickgliss.events.ListItemEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ComboBox;
   import com.pickgliss.ui.controls.list.VectorListModel;
   import com.pickgliss.ui.core.Disposeable;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import effortView.EffortController;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class EffortPullComboBox extends Sprite implements Disposeable
   {
       
      
      private const FULL:String = LanguageMgr.GetTranslation("tank.view.effort.EffortPullDodnMenu.FULL");
      
      private const ACQUIRE:String = LanguageMgr.GetTranslation("tank.view.effort.EffortPullDodnMenu.ACQUIRE");
      
      private const INCOMPLETE:String = LanguageMgr.GetTranslation("tank.view.effort.EffortPullDodnMenu.INCOMPLETE");
      
      private var _comboBox:ComboBox;
      
      private var _controller:EffortController;
      
      public function EffortPullComboBox(param1:EffortController)
      {
         this._controller = param1;
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._comboBox = ComponentFactory.Instance.creatComponentByStylename("effortView.EffortPullDodnMenu.PullDodnMenu");
         this._comboBox.beginChanges();
         this._comboBox.selctedPropName = "text";
         var _loc1_:VectorListModel = this._comboBox.listPanel.vectorListModel;
         _loc1_.append(this.FULL);
         _loc1_.append(this.ACQUIRE);
         _loc1_.append(this.INCOMPLETE);
         this._comboBox.listPanel.list.updateListView();
         this._comboBox.listPanel.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__itemClick);
         this._comboBox.button.addEventListener(MouseEvent.CLICK,this.__buttonClick);
         this._comboBox.commitChanges();
         addChild(this._comboBox);
         this._comboBox.textField.text = this.FULL;
      }
      
      private function __buttonClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      private function __itemClick(param1:ListItemEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.index)
         {
            case 0:
               this._controller.currentViewType = 0;
               break;
            case 1:
               this._controller.currentViewType = 1;
               break;
            case 2:
               this._controller.currentViewType = 2;
         }
      }
      
      public function dispose() : void
      {
         if(this._comboBox && this._comboBox.button && this._comboBox.listPanel && this._comboBox.listPanel.list)
         {
            this._comboBox.button.removeEventListener(MouseEvent.CLICK,this.__buttonClick);
            this._comboBox.listPanel.list.removeEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__itemClick);
         }
         this._comboBox.dispose();
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
