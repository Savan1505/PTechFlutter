abstract class Mapper<E, D> {
  D mapFromEntity(E type);

  E mapToEntity(D type);
}
