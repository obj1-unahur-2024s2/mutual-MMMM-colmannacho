class Actividad{
  const property idiomas = #{}
  method implicaEsfuerzo() = true
  method sirveParaBroncearse() = true
  method cuantosDiasLleva()   
  method esInteresante() = idiomas.size() > 1
  method esRecomendadaPor(unSocio) {
    return self.esInteresante() and unSocio.leAtrae(self) and !unSocio.actividades().contains(self)
  } 
}
class Playa inherits Actividad{
  const largo
  override method cuantosDiasLleva() = largo / 500
  override method implicaEsfuerzo() = largo > 1200
}
class ExcursionCiudad inherits Actividad {
  const atracciones
  override method cuantosDiasLleva() = atracciones / 2
  override method implicaEsfuerzo() = atracciones.between(5,8)
  override method sirveParaBroncearse() = false
  override method esInteresante() = super() || atracciones == 5
}
class ExcursionTropical inherits ExcursionCiudad {
  override method cuantosDiasLleva() = super() + 1
  override method sirveParaBroncearse() = true
}
class Trekking inherits Actividad{
  const kilometrosSenderos
  const diasDeSolAlAnio
  override method cuantosDiasLleva() = kilometrosSenderos / 50
  override method implicaEsfuerzo() = kilometrosSenderos > 80
  override method sirveParaBroncearse() {
    return diasDeSolAlAnio > 200 || (diasDeSolAlAnio.between(100,200) and kilometrosSenderos > 120)
  }
  override method esInteresante() = super() and diasDeSolAlAnio > 140
}
class Gimnasia inherits Actividad {
  //override method idiomas() = ["español"] NO RECOMENDADO POR EL PROFESOR
  method initialize() {
    idiomas.clear()
    idiomas.add("español")
  }
  override method cuantosDiasLleva() = 1
  override method sirveParaBroncearse() = false
  override method esRecomendadaPor(unSocio) = unSocio.edad().between(20,30)
}
class TallerIterario inherits Actividad{
  const libros = #{}
  method initialize() {
    idiomas.clear()
    idiomas.addAll(libros.map({c => c.idioma()}))
  }
  override method cuantosDiasLleva() = libros.size() + 1
  override method implicaEsfuerzo() {
    return libros.any({c => c.cantidadPaginas() > 500}) || (libros.map({c => c.nombreAutor()}).asSet().size() == 1 and libros.size() > 1) //libros.all({c,d => c.nombreAutor() == d.nombreAutor()
  }
  override method sirveParaBroncearse() = false
  override method esRecomendadaPor(unSocio) = unSocio.idiomas().size() > 1
}
class Libros {
  const property idioma
  const property cantidadPaginas
  const property nombreAutor
}
class Socio {
  var edad 
  const property idiomas = #{}
  const property actividades = []
  const maximoActividades
  method edad() = edad 
  method esAdoradorDelSol() = actividades.all({c => c.sirveParaBroncearse()})
  method actividadesEsforzadas() = actividades.filter({c => c.implicaEsfuerzo()})
  method registrarActividad(unaActividad) {
    if(maximoActividades == actividades.size()){
      self.error("Alcanzó el maximo de actividades")
    }
    actividades.add(unaActividad)
  }
  method leAtrae(unaActividad) 
}
class Tranquilo inherits Socio {
  override method leAtrae(unaActividad) = unaActividad.cuantosDiasLleva() >= 4
}
class Coherente inherits Socio {
  override method leAtrae(unaActividad) {
    return if(self.esAdoradorDelSol()) unaActividad.sirveParaBroncearse() else unaActividad.implicaEsfuerzo()
  }
}
class Relajado inherits Socio {
  override method leAtrae(unaActividad){
    return not idiomas.intersection(unaActividad.idiomas()).isEmpty()
  }
}