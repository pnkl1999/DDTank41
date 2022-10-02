/*
Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing{
	
	import flash.utils.Dictionary;
	
	/**
	 * KeyMap is a key definition -> action map.
	 * @see org.aswing.KeyDefinition
	 * @author iiley
	 */
	public class KeyMap{
		
		private var map:Dictionary;
		
		/**
		 * Creates a key map.
		 */
		public function KeyMap(){
			map = new Dictionary();
		}
		
		/**
		 * Registers a key definition -> action pair to the map. If same key definition is already 
		 * in the map, it will be replaced with the new one.
		 * @param key the key definition.
		 * @param action the aciton function
		 */
		public function registerKeyAction(key:KeyType, action:Function):void{
			var codec:String = getCodec(key);
			var list:Array = map[codec];
			if(list == null)
				list = new Array();
			list.push(new KeyAction(key,action));
			map[codec] = list;
		}
		
		/**
		 * Unregisters a key and its action value.
		 * @param key the key and its value to be unrigesterd.
		 */
		public function unregisterKeyAction(key:KeyType, action:Function):void{
			var codec:String = getCodec(key);
			var list:Array = map[codec];
			if(list)
			{
				for(var i:int =0;i < list.length;i++)
				{
					var ka:KeyAction = list[i];
					if(ka.action == action)
					{
						list.splice(i,1);
						i--;
					}
				}
			}
		}
		
		/**
		 * Returns the action from the key defintion.
		 * @param key the key definition
		 * @return the action.
		 * @see #getCodec()
		 */
		public function getKeyAction(key:KeyType):Function{
			return getKeyActionWithCodec(getCodec(key));
		}
		
		private function getKeyActionWithCodec(codec:String):Function{
			var list:Array = map[codec];
			if(list != null && list.length > 0){
				return list[list.length - 1].action;
			}
			return null;
		}
		
		/**
		 * Fires a key action with key sequence.
		 * @return whether or not a key action fired with this key sequence.
		 */
		public function fireKeyAction(keySequence:Array):Boolean{
			var codec:String = getCodecWithKeySequence(keySequence);
			var action:Function = getKeyActionWithCodec(codec);
			if(action != null){
				action();
				return true;
			}
			return false;
		}
		
		/**
		 * Returns whether the key definition is already registered.
		 * @param key the key definition
		 */
		public function containsKey(key:KeyType):Boolean{
			return map[getCodec(key)] != null;
		}
		
		/**
		 * Returns the codec of a key definition, same codec means same key definitions.
		 * @param key the key definition
		 * @return the codec of specified key definition
		 */
		public static function getCodec(key:KeyType):String{
			return getCodecWithKeySequence(key.getCodeSequence());
		}
		
		/**
		 * Returns the codec of a key sequence.
		 * @param keySequence the key sequence
		 * @return the codec of specified key sequence
		 */
		public static function getCodecWithKeySequence(keySequence:Array):String{
			return keySequence.join("|");
		}
	}
	
}

import org.aswing.KeyType;

class KeyAction{
	internal var key:KeyType;
	internal var action:Function;
	
	public function KeyAction(key:KeyType, action:Function){
		this.key = key;
		this.action = action;
	}
}