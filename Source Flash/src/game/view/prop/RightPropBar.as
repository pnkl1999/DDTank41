package game.view.prop
{
   import com.greensock.TweenLite;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BuffInfo;
   import ddt.data.EquipType;
   import ddt.data.FightPropMode;
   import ddt.data.PropInfo;
   import ddt.data.UsePropErrorCode;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.LivingEvent;
   import ddt.events.SharedEvent;
   import ddt.manager.DragManager;
   import ddt.manager.InGameCursor;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import game.model.LocalPlayer;
   import org.aswing.KeyStroke;
   import org.aswing.KeyboardManager;
   import trainer.controller.WeakGuildManager;
   import trainer.data.ArrowType;
   import trainer.data.Step;
   import trainer.view.NewHandContainer;
   
   public class RightPropBar extends FightPropBar
   {
       
      
      private var _startPos:Point;
      
      private var _mouseHolded:Boolean = false;
      
      private var _elasped:int = 0;
      
      private var _last:int = 0;
      
      private var _container:DisplayObjectContainer;
      
      private var _localVisible:Boolean = true;
      
      private var _tweenComplete:Boolean = true;
      
      private var cell:PropCell;
      
      private var _tempPlace:int;
      
      public function RightPropBar(param1:LocalPlayer, param2:DisplayObjectContainer)
      {
         this._container = param2;
         super(param1);
         this.setItems();
      }
      
      public function setup(param1:DisplayObjectContainer) : void
      {
         this._container = param1;
         this._container.addChild(this);
         if(_mode == FightPropMode.VERTICAL)
         {
            x = _background.width;
            if(SharedManager.Instance.propTransparent)
            {
               TweenLite.to(this,0.3,{
                  "x":0,
                  "alpha":0.5
               });
            }
            else
            {
               TweenLite.to(this,0.3,{
                  "x":0,
                  "alpha":1
               });
            }
         }
         else
         {
            y = 102;
            if(SharedManager.Instance.propTransparent)
            {
               TweenLite.to(this,0.3,{
                  "y":0,
                  "alpha":0.5
               });
            }
            else
            {
               TweenLite.to(this,0.3,{
                  "y":0,
                  "alpha":1
               });
            }
         }
      }
      
      private function setItems() : void
      {
         var _loc4_:* = null;
         var _loc5_:PropInfo = null;
         var _loc6_:Array = null;
         var _loc7_:InventoryItemInfo = null;
         var _loc1_:Boolean = false;
         var _loc2_:InventoryItemInfo = PlayerManager.Instance.Self.PropBag.findFistItemByTemplateId(EquipType.T_ALL_PROP,true,true);
         var _loc3_:Object = SharedManager.Instance.GameKeySets;
         for(_loc4_ in _loc3_)
         {
            if(int(_loc4_) == 9)
            {
               break;
            }
            _loc5_ = new PropInfo(ItemManager.Instance.getTemplateById(_loc3_[_loc4_]));
            if(_loc2_ || PlayerManager.Instance.Self.hasBuff(BuffInfo.FREE))
            {
               if(_loc2_)
               {
                  _loc5_.Place = _loc2_.Place;
               }
               else
               {
                  _loc5_.Place = -1;
               }
               _loc5_.Count = -1;
               _cells[int(_loc4_) - 1].info = _loc5_;
               _loc1_ = true;
            }
            else
            {
               _loc6_ = PlayerManager.Instance.Self.PropBag.findItemsByTempleteID(_loc3_[_loc4_]);
               if(_loc6_.length > 0)
               {
                  _loc5_.Place = _loc6_[0].Place;
                  for each(_loc7_ in _loc6_)
                  {
                     _loc5_.Count += _loc7_.Count;
                  }
                  _cells[int(_loc4_) - 1].info = _loc5_;
                  _loc1_ = true;
               }
               else
               {
                  _cells[int(_loc4_) - 1].info = _loc5_;
               }
            }
         }
         if(_loc1_)
         {
            this.updatePropByEnergy();
         }
      }
      
      override protected function updatePropByEnergy() : void
      {
         var _loc1_:PropCell = null;
         var _loc2_:PropInfo = null;
         for each(_loc1_ in _cells)
         {
            if(_loc1_.info)
            {
               _loc2_ = _loc1_.info;
               if(_loc2_)
               {
                  if(_self.energy < _loc2_.needEnergy)
                  {
                     _loc1_.enabled = false;
                     this.clearArrowByProp(_loc2_,false,true);
                  }
                  else if(!_self.twoKillEnabled && (_loc1_.info.TemplateID == EquipType.ADD_TWO_ATTACK || _loc1_.info.TemplateID == EquipType.ADD_ONE_ATTACK || _loc1_.info.TemplateID == EquipType.THREEKILL))
                  {
                     _loc1_.enabled = false;
                  }
                  else if(_loc1_.info.TemplateID == EquipType.THREEKILL)
                  {
                     _loc1_.enabled = _self.threeKillEnabled;
                  }
                  else
                  {
                     _loc1_.enabled = true;
                  }
               }
            }
         }
      }
      
      private function clearArrowByProp(param1:PropInfo, param2:Boolean = true, param3:Boolean = false) : void
      {
         if(!WeakGuildManager.Instance.switchUserGuide || PlayerManager.Instance.Self.IsWeakGuildFinish(Step.OLD_PLAYER))
         {
            return;
         }
         switch(param1.TemplateID)
         {
            case 10002:
               this.clearArr(ArrowType.TIP_ONE,param2);
               break;
            case 10003:
               this.clearArr(ArrowType.TIP_THREE,param2);
               if(!param3)
               {
                  this.clearArr(ArrowType.TIP_POWER,param2);
               }
               break;
            case 10008:
               this.clearArr(ArrowType.TIP_TEN_PERCENT,param2);
         }
      }
      
      private function clearArr(param1:int, param2:Boolean) : void
      {
         if(NewHandContainer.Instance.hasArrow(param1))
         {
            NewHandContainer.Instance.clearArrowByID(param1);
            if(param2)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("game.view.propContainer.ItemContainer.energy"));
            }
         }
      }
      
      override protected function __itemClicked(param1:MouseEvent) : void
      {
         var _loc2_:PropCell = null;
         var _loc3_:String = null;
         if(!this._localVisible)
         {
            return;
         }
         if(_enabled)
         {
            if(_self.isUsedPetSkillWithNoItem)
            {
               return;
            }
            _self.isUsedItem = true;
            _loc2_ = param1.currentTarget as PropCell;
            if(!_loc2_.enabled)
            {
               return;
            }
            SoundManager.instance.play("008");
            _loc3_ = _self.useProp(_loc2_.info,1);
            if(_loc3_ != UsePropErrorCode.Done && _loc3_ != UsePropErrorCode.None)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.prop." + _loc3_));
            }
            else if(_loc3_ == UsePropErrorCode.Done)
            {
               this.clearArrowByProp(_loc2_.info);
            }
            super.__itemClicked(param1);
            StageReferance.stage.focus = null;
         }
      }
      
      override protected function addEvent() : void
      {
         _self.addEventListener(LivingEvent.THREEKILL_CHANGED,this.__threeKillChanged);
         _self.addEventListener(LivingEvent.RIGHTENABLED_CHANGED,this.__rightEnabledChanged);
         _self.addEventListener(LivingEvent.SHOOT,this.__shoot);
         _self.addEventListener(LivingEvent.ATTACKING_CHANGED,this.__attackingChanged);
         _self.addEventListener(LocalPlayer.SET_ENABLE,this.__setEnable);
         SharedManager.Instance.addEventListener(SharedEvent.TRANSPARENTCHANGED,this.__transparentChanged);
         super.addEvent();
      }
      
      private function __setEnable(param1:Event) : void
      {
         var _loc2_:PropCell = null;
         for each(_loc2_ in _cells)
         {
            if(_loc2_.info.TemplateID == EquipType.ADD_TWO_ATTACK)
            {
               _loc2_.enabled = false;
            }
            if(_loc2_.info.TemplateID == EquipType.THREEKILL)
            {
               _loc2_.enabled = false;
            }
            if(_loc2_.info.TemplateID == EquipType.ADD_ONE_ATTACK)
            {
               _loc2_.enabled = false;
            }
         }
      }
      
      protected function __transparentChanged(param1:Event) : void
      {
         if(this._tweenComplete && parent)
         {
            if(SharedManager.Instance.propTransparent)
            {
               alpha = 0.5;
            }
            else
            {
               alpha = 1;
            }
         }
      }
      
      private function __attackingChanged(param1:LivingEvent) : void
      {
         if(_self.isAttacking && parent == null && this._localVisible)
         {
            TweenLite.killTweensOf(this,true);
            this._container.addChild(this);
            if(_mode == FightPropMode.VERTICAL)
            {
               alpha = 0;
               x = _background.width;
               if(SharedManager.Instance.propTransparent)
               {
                  TweenLite.to(this,0.3,{
                     "x":0,
                     "alpha":0.5,
                     "onComplete":this.showComplete
                  });
               }
               else
               {
                  TweenLite.to(this,0.3,{
                     "x":0,
                     "alpha":1,
                     "onComplete":this.showComplete
                  });
               }
               this._tweenComplete = false;
            }
            else
            {
               if(SharedManager.Instance.propTransparent)
               {
                  alpha = 0.5;
               }
               else
               {
                  alpha = 1;
               }
               x = 0;
               TweenLite.to(this,0.3,{"x":0});
            }
         }
         else if(!_self.isAttacking)
         {
            if(PlayerManager.Instance.Self.Grade > 15)
            {
               if(parent)
               {
                  this.hide();
               }
            }
         }
      }
      
      private function showComplete() : void
      {
         this._tweenComplete = true;
      }
      
      private function hide() : void
      {
         TweenLite.killTweensOf(this.cell);
         DragManager.__upDrag(null);
         InGameCursor.show();
         this._tweenComplete = false;
         TweenLite.to(this,0.3,{
            "alpha":0,
            "onComplete":this.hideComplete
         });
      }
      
      private function hideComplete() : void
      {
         this._tweenComplete = true;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      private function __shoot(param1:LivingEvent) : void
      {
         if(PlayerManager.Instance.Self.Grade > 15)
         {
            if(parent)
            {
               TweenLite.killTweensOf(this,true);
               this.hide();
            }
         }
      }
      
      override protected function __enabledChanged(param1:LivingEvent) : void
      {
         enabled = _self.propEnabled && _self.rightPropEnabled;
      }
      
      private function __rightEnabledChanged(param1:LivingEvent) : void
      {
         enabled = _self.propEnabled && _self.rightPropEnabled;
      }
      
      private function __threeKillChanged(param1:LivingEvent) : void
      {
         var _loc2_:PropCell = null;
         for each(_loc2_ in _cells)
         {
            if(_loc2_.info.TemplateID == EquipType.THREEKILL)
            {
               _loc2_.enabled = _self.threeKillEnabled;
            }
         }
      }
      
      override protected function __keyDown(param1:KeyboardEvent) : void
      {
         if(!_enabled)
         {
            return;
         }
         switch(param1.keyCode)
         {
            case KeyStroke.VK_1.getCode():
            case KeyStroke.VK_NUMPAD_1.getCode():
               _cells[0].useProp();
               break;
            case KeyStroke.VK_2.getCode():
            case KeyStroke.VK_NUMPAD_2.getCode():
               _cells[1].useProp();
               break;
            case KeyStroke.VK_3.getCode():
            case KeyStroke.VK_NUMPAD_3.getCode():
               _cells[2].useProp();
               break;
            case KeyStroke.VK_4.getCode():
            case KeyStroke.VK_NUMPAD_4.getCode():
               _cells[3].useProp();
               break;
            case KeyStroke.VK_5.getCode():
            case KeyStroke.VK_NUMPAD_5.getCode():
               _cells[4].useProp();
               break;
            case KeyStroke.VK_6.getCode():
            case KeyStroke.VK_NUMPAD_6.getCode():
               _cells[5].useProp();
               break;
            case KeyStroke.VK_7.getCode():
            case KeyStroke.VK_NUMPAD_7.getCode():
               _cells[6].useProp();
               break;
            case KeyStroke.VK_8.getCode():
            case KeyStroke.VK_NUMPAD_8.getCode():
               _cells[7].useProp();
         }
      }
      
      override protected function configUI() : void
      {
         _background = ComponentFactory.Instance.creatComponentByStylename("RightPropBack");
         addChild(_background);
         super.configUI();
      }
      
      override protected function drawCells() : void
      {
         var _loc2_:PropCell = null;
         var _loc1_:int = 0;
         while(_loc1_ < 8)
         {
            _loc2_ = new PropCell(String(_loc1_ + 1),_mode,true);
            _loc2_.addEventListener(MouseEvent.CLICK,this.__itemClicked);
            _loc2_.addEventListener(MouseEvent.MOUSE_DOWN,this.__DownItemHandler);
            addChild(_loc2_);
            _cells.push(_loc2_);
            _loc1_++;
         }
         this.drawLayer();
      }
      
      private function __DownItemHandler(param1:MouseEvent) : void
      {
         if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GAIN_TEN_PERSENT) && PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GAIN_ADDONE) && PlayerManager.Instance.Self.IsWeakGuildFinish(Step.THREE_OPEN) && PlayerManager.Instance.Self.IsWeakGuildFinish(Step.TWO_OPEN) && PlayerManager.Instance.Self.IsWeakGuildFinish(Step.THIRTY_OPEN) && this._tweenComplete == true)
         {
            this.cell = param1.currentTarget as PropCell;
            this._tempPlace = _cells.indexOf(this.cell) + 1;
            this._container.addEventListener(MouseEvent.MOUSE_UP,this.__UpItemHandler);
            TweenLite.to(this.cell,0.5,{"onComplete":this.OnCellComplete});
         }
      }
      
      private function OnCellComplete() : void
      {
         KeyboardManager.getInstance().isStopDispatching = true;
         this.cell.dragStart();
      }
      
      private function __UpItemHandler(param1:MouseEvent) : void
      {
         TweenLite.killTweensOf(this.cell);
         this._container.removeEventListener(MouseEvent.MOUSE_UP,this.__UpItemHandler);
      }
      
      override public function dispose() : void
      {
         if(_background)
         {
            ObjectUtils.disposeObject(_background);
            _background = null;
         }
         super.dispose();
      }
      
      override protected function removeEvent() : void
      {
         var _loc1_:PropCell = null;
         for each(_loc1_ in _cells)
         {
            _loc1_.removeEventListener(MouseEvent.CLICK,this.__itemClicked);
         }
         _self.removeEventListener(LivingEvent.THREEKILL_CHANGED,this.__threeKillChanged);
         _self.removeEventListener(LivingEvent.RIGHTENABLED_CHANGED,this.__rightEnabledChanged);
         _self.removeEventListener(LivingEvent.SHOOT,this.__shoot);
         _self.removeEventListener(LivingEvent.ATTACKING_CHANGED,this.__attackingChanged);
         _self.removeEventListener(LocalPlayer.SET_ENABLE,this.__setEnable);
         SharedManager.Instance.removeEventListener(SharedEvent.TRANSPARENTCHANGED,this.__transparentChanged);
         super.removeEvent();
      }
      
      override protected function drawLayer() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         this._startPos = ComponentFactory.Instance.creatCustomObject("RightPropPos" + _mode);
         var _loc1_:int = _cells.length;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            if(_mode == FightPropMode.VERTICAL)
            {
               _loc3_ = this._startPos.x + 5;
               _loc4_ = this._startPos.y + 6 + _loc2_ * (36 + 3);
            }
            else
            {
               _loc3_ = this._startPos.x + 6 + _loc2_ * (36 + 3);
               _loc4_ = this._startPos.y + 5;
            }
            _cells[_loc2_].setPossiton(_loc3_,_loc4_);
            _cells[_loc2_].setMode(_mode);
            if(_inited)
            {
               TweenLite.to(_cells[_loc2_],0.05 * (_loc1_ - _loc2_),{
                  "x":_loc3_,
                  "y":_loc4_
               });
            }
            else
            {
               _cells[_loc2_].x = _loc3_;
               _cells[_loc2_].y = _loc4_;
            }
            _loc2_++;
         }
         DisplayUtils.setFrame(_background,_mode);
         PositionUtils.setPos(_background,this._startPos);
      }
      
      override public function enter() : void
      {
         super.enter();
      }
      
      public function get mode() : int
      {
         return _mode;
      }
      
      public function setPropVisible(param1:int, param2:Boolean) : void
      {
         var _loc3_:PropCell = null;
         if(param1 < _cells.length)
         {
            _cells[param1].setVisible(param2);
            if(param2)
            {
               if(!_cells[param1].parent)
               {
                  addChild(_cells[param1]);
               }
            }
            else if(_cells[param1].parent)
            {
               _cells[param1].parent.removeChild(_cells[param1]);
            }
         }
         for each(_loc3_ in _cells)
         {
            if(_loc3_.localVisible)
            {
               this.setVisible(true);
               return;
            }
         }
         this.setVisible(false);
      }
      
      public function setVisible(param1:Boolean) : void
      {
         if(this._localVisible != param1)
         {
            this._localVisible = param1;
            if(this._localVisible)
            {
               if(_self.isAttacking && parent == null)
               {
                  this._container.addChild(this);
               }
            }
            else if(parent)
            {
               parent.removeChild(this);
            }
         }
      }
      
      public function hidePropBar() : void
      {
         this.visible = false;
      }
   }
}
