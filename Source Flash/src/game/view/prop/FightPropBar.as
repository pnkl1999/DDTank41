package game.view.prop
{
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.PropInfo;
   import ddt.events.LivingEvent;
   import ddt.manager.SharedManager;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import game.model.LocalPlayer;
   import org.aswing.KeyboardManager;
   
   public class FightPropBar extends Sprite implements Disposeable
   {
       
      
      protected var _mode:int;
      
      protected var _cells:Vector.<PropCell>;
      
      protected var _props:Vector.<PropInfo>;
      
      protected var _self:LocalPlayer;
      
      protected var _background:DisplayObject;
      
      protected var _enabled:Boolean = true;
      
      protected var _inited:Boolean = false;
      
      public function FightPropBar(param1:LocalPlayer)
      {
         this._mode = SharedManager.Instance.propLayerMode;
         this._cells = new Vector.<PropCell>();
         this._props = new Vector.<PropInfo>();
         super();
         this._self = param1;
         this.configUI();
         this.addEvent();
         this._inited = true;
      }
      
      public function enter() : void
      {
         this.addEvent();
         this.enabled = this._self.propEnabled;
      }
      
      public function leaving() : void
      {
         this.removeEvent();
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      protected function configUI() : void
      {
         this.drawCells();
      }
      
      protected function addEvent() : void
      {
         this._self.addEventListener(LivingEvent.ENERGY_CHANGED,this.__energyChange);
         this._self.addEventListener(LivingEvent.PROPENABLED_CHANGED,this.__enabledChanged);
         KeyboardManager.getInstance().addEventListener(KeyboardEvent.KEY_DOWN,this.__keyDown);
      }
      
      protected function __enabledChanged(param1:LivingEvent) : void
      {
         this.enabled = this._self.propEnabled;
      }
      
      protected function __keyDown(param1:KeyboardEvent) : void
      {
      }
      
      protected function __die(param1:LivingEvent) : void
      {
      }
      
      protected function __changeAttack(param1:LivingEvent) : void
      {
      }
      
      protected function __energyChange(param1:LivingEvent) : void
      {
         if(this._enabled)
         {
            this.updatePropByEnergy();
         }
      }
      
      protected function updatePropByEnergy() : void
      {
         var _loc1_:PropCell = null;
         var _loc2_:PropInfo = null;
         for each(_loc1_ in this._cells)
         {
            if(_loc1_.info)
            {
               _loc2_ = _loc1_.info;
               if(_loc2_)
               {
                  if(this._self.energy < _loc2_.needEnergy)
                  {
                     _loc1_.enabled = false;
                  }
                  else
                  {
                     _loc1_.enabled = true;
                  }
               }
            }
         }
      }
      
      protected function removeEvent() : void
      {
         this._self.removeEventListener(LivingEvent.ENERGY_CHANGED,this.__energyChange);
         this._self.removeEventListener(LivingEvent.PROPENABLED_CHANGED,this.__enabledChanged);
         KeyboardManager.getInstance().removeEventListener(KeyboardEvent.KEY_DOWN,this.__keyDown);
      }
      
      protected function drawLayer() : void
      {
      }
      
      protected function clearCells() : void
      {
         var _loc1_:PropCell = null;
         for each(_loc1_ in this._cells)
         {
            _loc1_.info = null;
         }
      }
      
      protected function drawCells() : void
      {
      }
      
      protected function __itemClicked(param1:MouseEvent) : void
      {
         StageReferance.stage.focus = null;
      }
      
      public function setMode(param1:int) : void
      {
         if(this._mode != param1)
         {
            this._mode = param1;
            this.drawLayer();
         }
      }
      
      public function get enabled() : Boolean
      {
         return this._enabled;
      }
      
      public function set enabled(param1:Boolean) : void
      {
         var _loc2_:PropCell = null;
         if(this._enabled != param1)
         {
            this._enabled = param1;
            if(this._enabled)
            {
               filters = null;
               this.updatePropByEnergy();
            }
            else
            {
               filters = [new ColorMatrixFilter([0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0,0,0,1,0])];
            }
            for each(_loc2_ in this._cells)
            {
               _loc2_.enabled = this._enabled;
            }
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:int = 0;
         this.removeEvent();
         if(this._cells)
         {
            _loc1_ = 0;
            while(_loc1_ < this._cells.length)
            {
               this._cells[_loc1_].dispose();
               this._cells[_loc1_] = null;
               _loc1_++;
            }
         }
         this._cells = null;
         if(this._background)
         {
            ObjectUtils.disposeObject(this._background);
         }
         this._background = null;
         this._self = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
