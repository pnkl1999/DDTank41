package game.view.prop
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.PropInfo;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   
   public class WeaponPropCell extends PropCell
   {
       
      
      private var _countField:FilterFrameText;
      
      public function WeaponPropCell(param1:String, param2:int)
      {
         super(param1,param2);
      }
      
      private static function creatDeputyWeaponIcon(param1:int) : Bitmap
      {
         switch(param1)
         {
            case EquipType.Angle:
               return ComponentFactory.Instance.creatBitmap("game.crazyTank.view.Prop29Asset");
            case EquipType.TrueAngle:
               return ComponentFactory.Instance.creatBitmap("game.crazyTank.view.Prop30Asset");
            case EquipType.ExllenceAngle:
               return ComponentFactory.Instance.creatBitmap("game.crazyTank.view.Prop35Asset");
            case EquipType.FlyAngle:
               return ComponentFactory.Instance.creatBitmap("game.crazyTank.view.Prop36Asset");
            case EquipType.TrueShield:
               return ComponentFactory.Instance.creatBitmap("game.crazyTank.view.Prop31Asset");
            case EquipType.ExcellentShield:
               return ComponentFactory.Instance.creatBitmap("game.crazyTank.view.Prop32Asset");
            case 17006:
               return ComponentFactory.Instance.creatBitmap("game.crazyTank.view.Prop42Asset");
            case 17012:
               return ComponentFactory.Instance.creatBitmap("game.crazyTank.view.Prop17012Asset");
            case 17013:
               return ComponentFactory.Instance.creatBitmap("game.crazyTank.view.Prop17013Asset");
            default:
               return null;
         }
      }
      
      override public function setPossiton(param1:int, param2:int) : void
      {
         super.setPossiton(param1,param2);
         this.x = _x;
         this.y = _y;
      }
      
      override protected function drawLayer() : void
      {
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         this._countField = ComponentFactory.Instance.creatComponentByStylename("game.PropCell.CountField");
         addChild(this._countField);
      }
      
      public function setCount(param1:int) : void
      {
         this._countField.text = param1.toString();
         this._countField.x = _back.width - this._countField.width;
         this._countField.y = _back.height - this._countField.height;
      }
      
      override public function set info(param1:PropInfo) : void
      {
         var _loc2_:DisplayObject = null;
         _loc2_ = null;
         var _loc3_:Bitmap = null;
         ShowTipManager.Instance.removeTip(this);
         _info = param1;
         _loc2_ = _asset;
         if(_info != null)
         {
            if(_info.Template.CategoryID != EquipType.OFFHAND && _info.Template.CategoryID != EquipType.TEMP_OFFHAND)
            {
               _loc3_ = ComponentFactory.Instance.creatBitmap("game.crazyTank.view.Prop" + _info.Template.Pic + "Asset");
            }
            else
            {
               _loc3_ = creatDeputyWeaponIcon(_info.TemplateID);
            }
            if(_loc3_)
            {
               _loc3_.smoothing = true;
               _loc3_.x = _loc3_.y = 3;
               _loc3_.width = _loc3_.height = 32;
               addChildAt(_loc3_,getChildIndex(_fore));
            }
            _asset = _loc3_;
            _tipInfo.info = _info.Template;
            _tipInfo.shortcutKey = _shortcutKey;
            ShowTipManager.Instance.addTip(this);
            buttonMode = true;
         }
         else
         {
            buttonMode = false;
         }
         if(_loc2_ != null)
         {
            ObjectUtils.disposeObject(_loc2_);
         }
         this._countField.visible = _info != null || _asset != null;
      }
      
      override public function useProp() : void
      {
         if(_info || _asset)
         {
            dispatchEvent(new MouseEvent(MouseEvent.CLICK));
         }
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._countField);
         this._countField = null;
         super.dispose();
      }
   }
}
