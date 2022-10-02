package ddt.view.tips
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BuffInfo;
   import ddt.manager.LanguageMgr;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class PayBuffListItem extends Sprite implements Disposeable
   {
       
      
      private var _icon:DisplayObject;
      
      private var _labelField:FilterFrameText;
      
      private var _timeField:FilterFrameText;
      
      private var _w:int;
      
      private var _h:int;
      
      private var _countField:FilterFrameText;
      
      public function PayBuffListItem(param1:BuffInfo)
      {
         super();
         this._icon = addChild(ComponentFactory.Instance.creatBitmap("asset.core.payBuffAsset" + param1.Type));
         var _loc2_:Point = ComponentFactory.Instance.creatCustomObject("asset.core.PayBuffIconSize");
         this._icon.width = _loc2_.x;
         this._icon.height = _loc2_.y;
         this._labelField = ComponentFactory.Instance.creatComponentByStylename("asset.core.PayBuffTipLabel");
         this._labelField.text = param1.buffName;
         addChild(this._labelField);
         this._countField = ComponentFactory.Instance.creatComponentByStylename("asset.core.PayBuffTipCount");
         if(param1.maxCount > 0 && param1.isSelf)
         {
            this._countField.text = param1.ValidCount + "/" + param1.maxCount;
         }
         addChild(this._countField);
         this._timeField = ComponentFactory.Instance.creatComponentByStylename("asset.core.PayBuffTipTime");
         this._timeField.text = param1.day + LanguageMgr.GetTranslation("day");
         addChild(this._timeField);
         this._h = this._icon.height;
         this._w = this._timeField.x + this._timeField.width;
      }
      
      override public function get width() : Number
      {
         return this._w;
      }
      
      override public function get height() : Number
      {
         return this._h;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._icon);
         this._icon = null;
         ObjectUtils.disposeObject(this._labelField);
         this._labelField = null;
         ObjectUtils.disposeObject(this._timeField);
         this._timeField = null;
         ObjectUtils.disposeObject(this._countField);
         this._countField = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
