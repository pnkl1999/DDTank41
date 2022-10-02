package game.view.buff
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.LivingEvent;
   import ddt.manager.PlayerManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import game.GameManager;
   import game.model.Living;
   import game.view.SpringArrowView;
   import game.view.propertyWaterBuff.PropertyWaterBuffBar;
   
   public class SelfBuffBar extends Sprite implements Disposeable
   {
       
      
      private var _buffCells:Vector.<BuffCell>;
      
      private var _back:Bitmap;
      
      private var _living:Living;
      
      private var _container:DisplayObjectContainer;
      
      private var _gameArrow:SpringArrowView;
      
      private var _propertyWaterBuffBar:PropertyWaterBuffBar;
      
      private var _trueWidth:Number;
      
      private var _propertyWaterBuffBarVisible:Boolean;
      
      public function SelfBuffBar(param1:DisplayObjectContainer, param2:SpringArrowView)
      {
         this._buffCells = new Vector.<BuffCell>();
         super();
         this._gameArrow = param2;
         this._container = param1;
      }
      
      public function dispose() : void
      {
         if(this._living)
         {
            this._living.removeEventListener(LivingEvent.BUFF_CHANGED,this.__updateCell);
         }
         var _loc1_:BuffCell = this._buffCells.shift();
         while(_loc1_)
         {
            ObjectUtils.disposeObject(_loc1_);
            _loc1_ = this._buffCells.shift();
         }
         this._buffCells = null;
         ObjectUtils.disposeObject(this._propertyWaterBuffBar);
         this._propertyWaterBuffBar = null;
         if(this._back)
         {
            ObjectUtils.disposeObject(this._back);
         }
         this._back = null;
      }
      
      public function drawBuff(param1:Living) : void
      {
         if(this._living)
         {
            this._living.removeEventListener(LivingEvent.BUFF_CHANGED,this.__updateCell);
         }
         this._living = param1;
         if(this._living)
         {
            this._living.addEventListener(LivingEvent.BUFF_CHANGED,this.__updateCell);
         }
         this.__updateCell(null);
      }
      
      private function __updateCell(param1:LivingEvent) : void
      {
         var _loc4_:BuffCell = null;
         var _loc5_:int = 0;
         _loc4_ = null;
         _loc5_ = 0;
         var _loc6_:int = 0;
         this.clearBuff();
         var _loc2_:int = this._living == null ? int(int(0)) : int(int(this._living.localBuffs.length));
         var _loc3_:int = this._living == null ? int(int(0)) : int(int(this._living.petBuffs.length));
         this._trueWidth = 0;
         if(_loc2_ + _loc3_ > 0 && this._buffCells)
         {
            if(_loc2_ > 0)
            {
               if(!this._back)
               {
                  this._back = ComponentFactory.Instance.creatBitmap("asset.game.selfBuff.back");
                  addChild(this._back);
               }
               this._trueWidth = this._back.width;
            }
            else if(this._back)
            {
               if(this._back)
               {
                  ObjectUtils.disposeObject(this._back);
               }
               this._back = null;
            }
            _loc5_ = 0;
            while(_loc5_ < _loc2_)
            {
               if(_loc5_ + 1 > this._buffCells.length)
               {
                  _loc4_ = new BuffCell(null,null,false,true);
                  this._buffCells.push(_loc4_);
               }
               else
               {
                  _loc4_ = this._buffCells[_loc5_];
               }
               _loc4_.x = _loc5_ % 10 * 36 + 8;
               _loc4_.y = -Math.floor(_loc5_ / 10) * 36 + 6;
               addChild(_loc4_);
               _loc4_.setInfo(this._living.localBuffs[_loc5_]);
               _loc4_.height = 32;
               _loc4_.width = 32;
               _loc5_++;
            }
            _loc6_ = 0;
            while(_loc6_ < _loc3_)
            {
               if(_loc6_ + 1 + _loc2_ > this._buffCells.length)
               {
                  _loc4_ = new BuffCell(null,null,false,true);
                  this._buffCells.push(_loc4_);
               }
               else
               {
                  _loc4_ = this._buffCells[_loc6_ + _loc2_];
               }
               if(_loc2_ > 0)
               {
                  _loc4_.x = (_loc6_ + _loc2_ > 3 ? _loc6_ + _loc2_ : _loc6_ + 3) % 10 * 36 + 15;
               }
               else
               {
                  _loc4_.x = (_loc6_ + _loc2_) % 10 * 36;
               }
               _loc4_.y = -Math.floor((_loc6_ + _loc2_) / 10) * 36 + 6;
               _loc4_.setInfo(this._living.petBuffs[_loc6_]);
               addChild(_loc4_);
               this._trueWidth = _loc4_.x + 32;
               _loc6_++;
            }
            if(parent == null && GameManager.Instance.Current.mapIndex != 1405)
            {
               if(this._container.contains(this._gameArrow))
               {
                  this._container.addChildAt(this,this._container.getChildIndex(this._gameArrow));
               }
               else
               {
                  this._container.addChild(this);
               }
            }
         }
         else if(parent)
         {
            parent.removeChild(this);
         }
         this.createPropertyWaterBuffBar();
      }
      
      private function createPropertyWaterBuffBar() : void
      {
         if(PropertyWaterBuffBar.getPropertyWaterBuffList(PlayerManager.Instance.Self.buffInfo).length > 0)
         {
            if(!this._propertyWaterBuffBar)
            {
               this._propertyWaterBuffBar = new PropertyWaterBuffBar();
               PositionUtils.setPos(this._propertyWaterBuffBar,"game.view.propertyWaterBuff.PropertyWaterBuffBarPos");
               this._propertyWaterBuffBar.visible = this._propertyWaterBuffBarVisible;
               addChild(this._propertyWaterBuffBar);
            }
            this._propertyWaterBuffBar.x = this._trueWidth == 0 ? Number(Number(6)) : Number(Number(this._trueWidth + 6));
            if(parent == null && GameManager.Instance.Current.mapIndex != 1405)
            {
               if(this._container.contains(this._gameArrow))
               {
                  this._container.addChildAt(this,this._container.getChildIndex(this._gameArrow));
               }
               else
               {
                  this._container.addChild(this);
               }
            }
         }
      }
      
      public function set propertyWaterBuffBarVisible(param1:Boolean) : void
      {
         this._propertyWaterBuffBarVisible = param1;
         if(this._propertyWaterBuffBar)
         {
            this._propertyWaterBuffBar.visible = this._propertyWaterBuffBarVisible;
         }
      }
      
      public function get right() : Number
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(this._living == null || this._living.localBuffs.length == 0)
         {
            _loc1_ = this._living == null ? int(int(0)) : int(int(this._living.petBuffs.length));
            _loc2_ = _loc1_ > 8 ? int(int(8)) : int(int(_loc1_));
            return x + _loc2_ * 44 + 40;
         }
         _loc3_ = this._living == null ? int(int(0)) : int(int(this._living.localBuffs.length));
         _loc4_ = this._living == null ? int(int(0)) : int(int(this._living.petBuffs.length));
         _loc5_ = _loc3_ + _loc4_ > 8 ? int(int(8)) : int(int(_loc3_ + _loc4_));
         return x + _loc5_ * 44 + 40;
      }
      
      private function clearBuff() : void
      {
         var _loc1_:BuffCell = null;
         for each(_loc1_ in this._buffCells)
         {
            _loc1_.clearSelf();
         }
      }
   }
}
