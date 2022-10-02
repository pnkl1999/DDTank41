package bagAndInfo.cell
{
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.view.PropItemView;
   import ddt.view.character.BaseLayer;
   import ddt.view.character.ILayer;
   import ddt.view.character.ILayerFactory;
   import ddt.view.character.LayerFactory;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class CellContentCreator extends Sprite implements Disposeable
   {
       
      
      private var _factory:ILayerFactory;
      
      private var _loader:ILayer;
      
      private var _callBack:Function;
      
      private var _timer:Timer;
      
      private var _info:ItemTemplateInfo;
      
      private var _w:Number;
      
      private var _h:Number;
      
      public function CellContentCreator()
      {
         super();
         this._factory = LayerFactory.instance;
      }
      
      public function set info(param1:ItemTemplateInfo) : void
      {
         this._info = param1;
      }
      
      public function loadSync(param1:Function) : void
      {
         var _loc2_:String = null;
         this._callBack = param1;
         if(this._info.CategoryID == EquipType.FRIGHTPROP)
         {
            this._timer = new Timer(50,1);
            this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.__timerComplete);
            this._timer.start();
         }
         else
         {
            if(this._info is InventoryItemInfo)
            {
               _loc2_ = EquipType.isEditable(this._info) && InventoryItemInfo(this._info).Color != null ? InventoryItemInfo(this._info).Color : "";
               this._loader = this._factory.createLayer(this._info,this._info.NeedSex == 1,_loc2_,BaseLayer.ICON);
            }
            else
            {
               this._loader = this._factory.createLayer(this._info,this._info.NeedSex == 1,"",BaseLayer.ICON);
            }
            this._loader.load(this.loadComplete);
         }
      }
      
      public function clearLoader() : void
      {
         if(this._loader != null)
         {
            this._loader.dispose();
            this._loader = null;
         }
      }
      
      private function __timerComplete(param1:TimerEvent) : void
      {
         if(this._timer)
         {
            this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__timerComplete);
            this._timer.stop();
         }
         addChild(PropItemView.createView(this._info.Pic) as Bitmap);
         this._callBack();
      }
      
      private function loadComplete(param1:ILayer) : void
      {
         addChild(param1.getContent());
         this._callBack();
      }
      
      public function setColor(param1:*) : Boolean
      {
         if(this._loader != null)
         {
            return this._loader.setColor(param1);
         }
         return false;
      }
      
      public function get editLayer() : int
      {
         if(this._loader == null)
         {
            return 1;
         }
         return this._loader.currentEdit;
      }
      
      override public function set width(param1:Number) : void
      {
         super.width = param1;
         this._w = param1;
      }
      
      override public function set height(param1:Number) : void
      {
         super.height = param1;
         this._h = param1;
      }
      
      public function dispose() : void
      {
         this._factory = null;
         if(this._loader != null)
         {
            this._loader.dispose();
         }
         this._loader = null;
         if(this._timer != null)
         {
            this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__timerComplete);
            this._timer.stop();
            this._timer = null;
         }
         this._callBack = null;
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
