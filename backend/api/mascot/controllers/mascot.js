'use strict';

/**
 * Read the documentation (https://strapi.io/documentation/developer-docs/latest/concepts/controllers.html#core-controllers)
 * to customize this controller
 */
const { parseMultipartData, sanitizeEntity } = require('strapi-utils');

function getEdad(dateString) {
    let hoy = new Date()
    let dd = hoy.getDate()
    let mm = hoy.getMonth() + 1
    let yyyy = hoy.getFullYear()
    let fechaNacimiento = new Date(dateString)
    let edad = hoy.getFullYear() - fechaNacimiento.getFullYear()
    let diferenciaMeses = hoy.getMonth() - fechaNacimiento.getMonth()
       
    if (
      diferenciaMeses < 0 ||
      (diferenciaMeses === 0 && hoy.getDate() < fechaNacimiento.getDate())
    ) {
      edad--
    }
    return edad 

  }
function getEdadApro(dateString) {
    let hoy = new Date()
    let dd = hoy.getDate()
    let mm = hoy.getMonth() + 1
    let yyyy = hoy.getFullYear() 
    let fechaNacimiento = new Date(dateString) 
    let edad = hoy.getFullYear() - fechaNacimiento.getFullYear() 
   
    if (dateString != 0 ) {
        var yy = yyyy - dateString
        var today = yy + '-' + mm + '-' + dd;
  
       console.log(getEdad(today));
      }

    
    return today 

  }



module.exports = {

/**
   * Create a record.
   *
   * @return {Object}
   */

 async create(ctx) {
    let entity;
    if (ctx.is('multipart')) {
      const { data, files } = parseMultipartData(ctx);
      entity = await strapi.services.mascot.create(data, { files });
    } else {   
     
        if (ctx.request.body.edad != 0 ) {
           var tipo_edad= true;
          } else  { tipo_edad= false}
       //console.log(ctx.request.body);
        const pets = {
            "name": ctx.request.body.name,
            "edad": getEdadApro(ctx.request.body.edad),
            "tipo_edad": tipo_edad,
            "sexo": ctx.request.body.sexo,
            "raza": ctx.request.body.raza,
            "fecha": ctx.request.body.fecha       
        }     
        entity = await strapi.services.mascot.create(pets);

    }     

    const response = {
        response: ctx.response,
        transactionsid: entity.id        
      };              

    
    return response;
    //return sanitizeEntity(entity, { model: strapi.models.transactions });
  },

      async find(ctx) {
        let entities;         
              
                if (ctx.query._q) {
                  entities = await strapi.services.mascot.search(ctx.query );   
                
                } else {
                  entities = await strapi.services.mascot.find(ctx.query);                    
            
            
              return entities.map(entity => sanitizeEntity(entity, { model: strapi.models.mascot }));
           }

      },
     

};

