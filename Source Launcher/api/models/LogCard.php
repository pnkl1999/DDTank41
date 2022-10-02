<?php

namespace Models;

use Illuminate\Database\Eloquent\Model;

class LogCard extends Model
{
    protected $table='Log_Card';
    
    protected $primaryKey='id';
    
    public $timestamps = false;
    
    protected $guarded = ['id'];
}