package ddt.view.caddyII.offerPack
{
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.events.ListItemEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ComboBox;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   
   public class OfferComboBox extends ComboBox
   {
      
      public static const P_LISTITEM:String = "listItem";
       
      
      protected var _offerItemStyle:String;
      
      protected var _offerItem:OfferItem;
      
      public function OfferComboBox()
      {
         super();
      }
      
      public function set offerItemStyle(param1:String) : void
      {
         if(this._offerItemStyle == param1)
         {
            return;
         }
         this._offerItemStyle = param1;
         this._offerItem = ComponentFactory.Instance.creat(this._offerItemStyle);
      }
      
      public function set offerItem(param1:OfferItem) : void
      {
         if(this._offerItem == param1)
         {
            return;
         }
         this._offerItem = param1;
         onPropertiesChanged(P_textField);
      }
      
      public function get offerItem() : OfferItem
      {
         return this._offerItem;
      }
      
      override protected function __onItemChanged(param1:ListItemEvent) : void
      {
         _currentSelectedItem = param1.cell;
         _currentSelectedCellValue = param1.cellValue;
         _currentSelectedIndex = param1.index;
         if(_selctedPropName != null)
         {
            this._offerItem.info = param1.cell[_selctedPropName];
         }
         dispatchEvent(new InteractiveEvent(InteractiveEvent.STATE_CHANGED));
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         if(this._offerItem)
         {
            addChild(this._offerItem);
         }
      }
      
      override public function dispose() : void
      {
         if(this._offerItem)
         {
            ObjectUtils.disposeObject(this._offerItem);
         }
         this._offerItem = null;
         super.dispose();
      }
      
      override protected function __onStageClick(param1:MouseEvent) : void
      {
         var _loc2_:DisplayObject = param1.target as DisplayObject;
         if(!DisplayUtils.isTargetOrContain(_loc2_,this) && !DisplayUtils.isTargetOrContain(_loc2_,_listPanel))
         {
            return;
         }
         if(DisplayUtils.isTargetOrContain(_loc2_,_button) || DisplayUtils.isTargetOrContain(_loc2_,_listPanel.list) || DisplayUtils.isTargetOrContain(_loc2_,this._offerItem))
         {
            if(_state == ComboBox.HIDE)
            {
               SoundManager.instance.play("008");
               doShow();
            }
            else
            {
               SoundManager.instance.play("008");
               doHide();
            }
         }
      }
   }
}
