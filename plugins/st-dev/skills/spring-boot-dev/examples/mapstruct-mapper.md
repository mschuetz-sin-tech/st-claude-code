# MapStruct Mapper Examples

## Simple Mapper with Field Mappings

When entity field names don't match DTO field names, use `@Mapping` annotations:

```java
package com.company.project.mapper;

import com.company.project.domain.persistent.CompoundPlateTypeEntity;
import com.company.project.dto.CompoundPlateTypeDTO;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

import java.util.List;

@Mapper(componentModel = "spring")
public interface CompoundPlateTypeMapper {

    @Mapping(source = "compoundPlateTypeId", target = "id")
    @Mapping(source = "compoundPlateTypeName", target = "name")
    CompoundPlateTypeDTO toDTO(CompoundPlateTypeEntity entity);

    List<CompoundPlateTypeDTO> toDTOList(List<CompoundPlateTypeEntity> entities);
}
```

## Usage in Service

Always inject the mapper and use it - never write manual mapping methods:

```java
@Service
@RequiredArgsConstructor
public class LookupDataService {

    private final CompoundPlateTypeRepository plateTypeRepository;
    private final CompoundPlateTypeMapper plateTypeMapper;  // Inject mapper

    public List<CompoundPlateTypeDTO> getPlateTypes() {
        return plateTypeMapper.toDTOList(plateTypeRepository.findAllByIsDeletedFalse());
    }
}
```

## Anti-Pattern: Manual Mapping in Service

**NEVER** do this - always use MapStruct mappers:

```java
// BAD - Don't write manual mapping methods in services
public List<CompoundPlateTypeDTO> getPlateTypes() {
    return plateTypeRepository.findAllByIsDeletedFalse().stream()
        .map(this::toPlateTypeDTO)  // Manual mapping method
        .toList();
}

private CompoundPlateTypeDTO toPlateTypeDTO(CompoundPlateTypeEntity entity) {
    return CompoundPlateTypeDTO.builder()
        .id(entity.getCompoundPlateTypeId())
        .name(entity.getCompoundPlateTypeName())
        .build();
}
```

## Mapper with @Context for Batch Operations

When mapping a list of entities and you need additional data (e.g., calculated values), use `@Context` to avoid N+1 queries:

```java
@Mapper(componentModel = "spring")
public interface ShipmentMapper {

    @Mapping(source = "shipment.shipmentId", target = "shipmentId")
    @Mapping(source = "shipment.compound.creluxCompoundCode", target = "creluxCompoundCode")
    @Mapping(target = "remainingQuantity", expression = "java(calculateRemaining(shipment, dilutionSums))")
    ShipmentDTO toDTO(CompoundShipmentEntity shipment, @Context Map<Integer, Double> dilutionSums);

    List<ShipmentDTO> toDTOList(List<CompoundShipmentEntity> shipments, @Context Map<Integer, Double> dilutionSums);

    default Double calculateRemaining(CompoundShipmentEntity shipment, Map<Integer, Double> dilutionSums) {
        double quantity = shipment.getCompoundQuantityMg() != null ? shipment.getCompoundQuantityMg() : 0.0;
        double diluted = dilutionSums.getOrDefault(shipment.getShipmentId(), 0.0);
        return quantity - diluted;
    }
}
```

**Usage in Service:**

```java
public List<ShipmentDTO> getShipments() {
    List<CompoundShipmentEntity> shipments = shipmentRepository.findAll();

    // Batch-load additional data ONCE
    Map<Integer, Double> dilutionSums = loadDilutionSums(shipments);

    // Pass as @Context - no N+1 queries
    return shipmentMapper.toDTOList(shipments, dilutionSums);
}
```
