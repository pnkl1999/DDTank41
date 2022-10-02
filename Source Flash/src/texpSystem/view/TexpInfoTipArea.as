package texpSystem.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class TexpInfoTipArea extends Sprite implements Disposeable
   {
       
      
      private var _tip:TexpInfoTip;
      
      private var _info:PlayerInfo;
      
      public function TexpInfoTipArea()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         addEventListener(MouseEvent.ROLL_OVER,this.__over);
         addEventListener(MouseEvent.ROLL_OUT,this.__out);
         var _loc1_:Point = ComponentFactory.Instance.creatCustomObject("texpSystem.texpInfoTipArea.size");
         graphics.beginFill(0,0);
         graphics.drawRect(0,0,_loc1_.x,_loc1_.y);
         graphics.endFill();
         this._tip = new TexpInfoTip();
      }
      
      public function set info(param1:PlayerInfo) : void
      {
         if(!param1)
         {
            return;
         }
         this._info = param1;
         this._tip.tipData = this._info;
      }
      
      private function __over(param1:MouseEvent) : void
      {
         var _loc2_:Point = null;
         if(!this._tip.parent && this._info)
         {
            _loc2_ = localToGlobal(new Point(0,0));
            this._tip.x = _loc2_.x;
            this._tip.y = _loc2_.y + width;
            LayerManager.Instance.addToLayer(this._tip,LayerManager.GAME_TOP_LAYER);
         }
      }
      
      private function __out(param1:MouseEvent) : void
      {
         if(this._tip.parent)
         {
            this._tip.parent.removeChild(this._tip);
         }
      }
      
      public function dispose() : void
      {
         removeEventListener(MouseEvent.ROLL_OVER,this.__over);
         removeEventListener(MouseEvent.ROLL_OUT,this.__out);
         ObjectUtils.disposeObject(this._tip);
         this._tip = null;
         this._info = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
